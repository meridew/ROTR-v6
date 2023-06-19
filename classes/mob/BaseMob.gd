class_name BaseMob extends RigidBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var player

var stats: Stats
var statuses: Statuses
var intended_velocity: Vector2 = Vector2.ZERO
var states: Dictionary = {}
var mob_state: State
var mob_scale

func _init():
	
	mob_scale = randf_range(0.5, 2)

	stats = Stats.new()
	stats.add_stat('speed', randf_range(80, 120))
	stats.add_stat('scale', mob_scale)
	stats.add_stat('mass', mob_scale * 10.0)
	
	statuses = Statuses.new()
	statuses.add_status('wander', 1.6, 10)
	
	states = {
		State.Type.IDLE: State.IdleState.new(self),
		State.Type.DEFAULT: State.DefaultState.new(self),
		State.Type.CHARGE: State.ChargeState.new(self),
		State.Type.LUNGE: State.LungeState.new(self),
		State.Type.CIRCLE: State.CircleState.new(self),
		State.Type.RETREAT: State.RetreatState.new(self)
		
	}
	
	change_state(State.Type.LUNGE)

func _ready():
	global_position = Vector2(randi_range(-500,500),randi_range(-500,500))
	animated_sprite.set_frame_and_progress(randf_range(0, animated_sprite.sprite_frames.get_frame_count('moving')), randf())
	animated_sprite.scale = Vector2(stats.scale.current_value,stats.scale.current_value)
	collision_shape.scale = Vector2(stats.scale.current_value,stats.scale.current_value)

func _process(delta):
	stats.update_modifiers(delta)
	statuses.update_statuses(delta)

func _physics_process(delta):
	mob_state.behavior(delta)

func _integrate_forces(state):
	state.set_linear_velocity(intended_velocity)

func change_state(state_name: State.Type):
	mob_state = states[state_name]

func set_sprite(direction: Vector2):
	if direction == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("moving")
	flip_sprite(direction)

func flip_sprite(direction):
	if direction.x < 0:
		animated_sprite.set_flip_h(true)
	elif direction.x > 0:
		animated_sprite.set_flip_h(false)

func set_player(player):
	self.player = player

func get_angle_of_player(): # replace with global get_angle(node) function at some point for all 
	var player_angle = (Global.player.global_position - global_position).angle()
	return player_angle
