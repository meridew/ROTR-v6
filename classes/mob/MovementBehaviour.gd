class_name MovementBehaviour extends Node

enum Behaviour {IDLE, CHASING, WANDERING, CHARGING}

var behaviour = Behaviour.CHASING
var target_position = null
var temp_target = null  # temporary target for charging
var speed = 100.0
var timer = Timer.new()

func _ready():
	await get_tree().process_frame
	timer.start()

func set_behaviour(new_behaviour):
	behaviour = new_behaviour
	timer.stop()

	match new_behaviour:
		Behaviour.IDLE:
			target_position = owner.global_position  # make the mob stationary
		Behaviour.CHASING:
			target_position = Global.player.global_position
		Behaviour.WANDERING:
			_start_wandering()
		Behaviour.CHARGING:
			_start_charging()

func _start_wandering():
	# wander for 5 seconds, then idle for 3
	target_position = Global.player.global_position + Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * speed
	timer.start(5.0)
	timer.connect("timeout", Callable(self, "_end_wandering"))

func _end_wandering():
	behaviour = Behaviour.IDLE
	timer.start(3.0)
	timer.connect("timeout", Callable(self, "_resume_wandering"))

func _resume_wandering():
	behaviour = Behaviour.WANDERING
	_start_wandering()

func _start_charging():
	# idle for 2 seconds, then charge towards player's current position
	behaviour = Behaviour.IDLE
	timer.start(2.0)
	timer.connect("timeout", Callable(self, "_end_charging"))

func _end_charging():
	speed *= 2  # double the speed
	temp_target = Global.player.global_position
	behaviour = Behaviour.CHASING
	timer.start(3.0)
	timer.connect("timeout", Callable(self, "_resume_charging"))

func _resume_charging():
	speed /= 2  # reset to original speed
	temp_target = null  # clear the temporary target
	behaviour = Behaviour.IDLE
	_start_charging()
