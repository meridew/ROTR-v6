class_name MobPool extends Node2D

@onready var mob_scene = preload("res://classes/mob/BaseMob.tscn")

var boss_mobs_max = 10
var boss_mob_pool_active = {}
var boss_mob_pool_inactive = {}
var mobs_max = 500
var mob_pool_active = {}
var mob_pool_inactive = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	init_mob_pool_inactive()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_mob_pool_inactive():
	var mob
	for i in range(mobs_max):
		mob = mob_scene.instantiate()
		mob.set_player(Global.player)
		var rand = State.Type.values()[randi() % State.Type.size()]
		mob.change_state(rand)
		mob_pool_inactive[mob.get_instance_id()] = mob
		add_child(mob)

func acquire_mob():
	var pool_inactive = mob_pool_inactive
	var pool_active = mob_pool_active

	if len(pool_inactive) > 0:
		var mob = pool_inactive[pool_inactive.keys()[0]]
		pool_inactive.erase(mob.get_instance_id())
		pool_active[mob.get_instance_id()] = mob
		return mob

func enable_mob(mob):
	mob.show()
	mob.set_physics_process(true)
	mob.set_process(true)
	
func disable_mob(mob):
	mob.hide()
	mob.set_physics_process(false)
	mob.set_process(false)
