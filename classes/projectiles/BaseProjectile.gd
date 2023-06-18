extends Area2D

var target
var stats: Stats
var equipment_stats: Stats
var velocity = Vector2.ZERO

func _init():
	stats = Stats.new()
	
func _ready():
	global_position = Global.player.global_position
	velocity = Vector2(stats.speed.current_value, 0).rotated(Global.player.closest_mob_angle)

func _process(delta):
	global_position += velocity * delta
