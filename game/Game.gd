extends Node2D

@onready var level = preload("res://levels/Level.tscn").instantiate()
@onready var player = preload("res://classes/Player/BasePlayer.tscn").instantiate()
@onready var mob_pool = preload("res://classes/pools/mob_pool/MobPool.tscn").instantiate()

@onready var projectiles = $Projectiles

func _ready():
	Global.level = level
	Global.player = player
	Global.mob_pool = mob_pool
	Global.projectiles = projectiles
	
	add_child(level)
	add_child(player)
	add_child(mob_pool)
