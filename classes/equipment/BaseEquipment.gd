class_name BaseEquipment extends Node2D

@onready var projectile_scene = preload("res://classes/projectiles/BaseProjectile.tscn")

@onready var fire_timer = $FireTimer

var stats: Stats
var projectile

func _init():
	stats = Stats.new()
	stats.add_stat('damage',100)
	stats.add_stat('speed',500)
	stats.add_stat('scale',1)
	stats.add_stat('passthrough',0)
	stats.add_stat('knockback',10)
	stats.add_stat('frequency',0.1)

func _ready():
	fire_timer.wait_time = stats.frequency.current_value

func _on_fire_timer_timeout():
	fire()
	
func fire():
	projectile = projectile_scene.instantiate()
	projectile.stats = stats
	if Global.player.closest_mob_angle:
		Global.projectiles.add_child(projectile)
