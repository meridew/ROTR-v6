class_name Mob extends RigidBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var target

var stats: Stats
var statuses: Statuses

var current_speed = 0.0

func _init():
	stats = Stats.new()
	stats.add_stat('speed',randi_range(80,120))
	stats.add_stat('acceleration',randi_range(20000,30000))
	stats.add_stat('deceleration',randi_range(20000,30000))
	statuses = Statuses.new()
	statuses.add_status('wander',100,3)
	#hide()
	#set_physics_process(false)
	#set_process(false)

# Called when the node enters the scene tree for the first time.

func _process(delta):
	stats.update_modifiers(delta)
	statuses.update_statuses(delta)
	
func _ready():
	animated_sprite.frame = randi() % animated_sprite.sprite_frames.get_frame_count(animated_sprite.animation)
	global_position = Vector2(randi_range(-1000,1000),randi_range(-1000,1000))

func set_target(_target):
	target = _target

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if target == null:
		return

	var direction = (target.global_position - global_position).normalized()
	wander()
	accelerate(direction)
	apply_central_force(direction * current_speed)
	clamp_speed()
	flip_sprite(direction)

func wander():
	if statuses.wander:
		var wandering_direction = Vector2.RIGHT.rotated(randf_range(-max_wandering_angle, max_wandering_angle))
		var wandering_timer = rand_range(0.0, max_wandering_time)
		direction = wandering_direction.normalized()

func accelerate(direction: Vector2) -> void:
	if direction.length() > 0:
		current_speed += stats.acceleration.current_value
		if current_speed > stats.speed.current_value:
			current_speed = stats.speed.current_value
	else:
		decelerate()

func decelerate() -> void:
	current_speed -= stats.deceleration.current_value
	if current_speed < 0:
		current_speed = 0

func clamp_speed() -> void:
	if linear_velocity.length() > stats.speed.current_value:
		linear_velocity = linear_velocity.normalized() * stats.speed.current_value

func flip_sprite(direction_to_player):
	if direction_to_player.x < 0 and not animated_sprite.flip_h:
		animated_sprite.flip_h = true
	elif direction_to_player.x > 0 and animated_sprite.flip_h:
		animated_sprite.flip_h = false
