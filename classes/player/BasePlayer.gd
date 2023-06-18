class_name BasePlayer extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var mob_detection_area = $MobDetetctionArea

var stats: Stats
var mobs_in_detection_area: Dictionary = {}
var random_mob = null
var closest_mob = null
var closest_mob_angle = null
var mob_check_elapsed_time = 0.0
var mob_check_interval = 0.1
var input_direction = Vector2.ZERO


func _init():
	stats = Stats.new()
	stats.add_stat('hp',100)
	stats.add_stat('hp_max',100)
	stats.add_stat('speed',300)

func _physics_process(_delta):
	get_input()
	update_animation()

func _process(delta):
	mob_check_elapsed_time += delta
	if mob_check_elapsed_time >= mob_check_interval:
		get_mob_data()
		mob_check_elapsed_time = 0.0

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")

	if input_direction.length() > 0:
		input_direction = input_direction.normalized()
		velocity = input_direction * stats.speed.current_value
		animated_sprite.set_flip_h(input_direction.x < 0)
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func update_animation():
	if velocity == Vector2.ZERO:
		if animated_sprite.animation != "idle":
			animated_sprite.animation = "idle"
	else:
		if animated_sprite.animation != "moving":
			animated_sprite.animation = "moving"

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
