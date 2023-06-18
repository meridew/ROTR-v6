class_name BasePlayer extends RigidBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var mob_detection_area = $MobDetetctionArea

var stats: Stats
var statuses: Statuses

var mobs_in_detection_area: Dictionary = {}
var random_mob = null
var closest_mob = null
var closest_mob_angle = null
var mob_check_elapsed_time = 0.0
var mob_check_interval = 0.1
var input_direction = Vector2.ZERO

func _init():
	mass = 100
	stats = Stats.new()
	stats.add_stat('hp',100)
	stats.add_stat('hp_max',100)
	stats.add_stat('speed',300)
	
	statuses = Statuses.new()

func _integrate_forces(state):
	var direction = Vector2()
	if Input.is_action_pressed("up"):
		direction.y -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("right"):
		direction.x += 1

	direction = direction.normalized() * stats.speed.current_value
	state.set_linear_velocity(direction)
	
	flip_sprite(direction)

func _process(delta):
	update_mob_data(delta)
	stats.update_modifiers(delta)
	statuses.update_statuses(delta)

func update_mob_data(delta):
	mob_check_elapsed_time += delta
	if mob_check_elapsed_time >= mob_check_interval:
		get_mob_data()
		mob_check_elapsed_time = 0.0
		
func get_mob_data():
	get_random_mob()
	get_closest_mob()
	get_closest_mob_angle()

func get_random_mob():
	randomize()
	if mobs_in_detection_area.size() > 0:
		var random_index = randi() % mobs_in_detection_area.size()
		random_mob = mobs_in_detection_area.keys()[random_index]
	else:
		random_mob = null

func get_closest_mob():
	closest_mob = null
	var closest_mob_squared_distance = INF
	for mob in mobs_in_detection_area.values():
		var squared_distance = (mob.global_position - global_position).length_squared()
		if squared_distance < closest_mob_squared_distance:
			closest_mob = mob
			closest_mob_squared_distance = squared_distance

func get_closest_mob_angle():
	closest_mob_angle = (closest_mob.global_position - global_position).angle() if closest_mob else null

func _on_mob_detetction_area_body_entered(body):
	if body.get_instance_id() not in mobs_in_detection_area:
		mobs_in_detection_area[body.get_instance_id()] = body

func _on_mob_detetction_area_body_exited(body):
	if body.get_instance_id() in mobs_in_detection_area:
		mobs_in_detection_area.erase(body.get_instance_id())

func flip_sprite(direction):
	if direction.x < 0:
		animated_sprite.set_flip_h(true)
	elif direction.x > 0:
		animated_sprite.set_flip_h(false)
