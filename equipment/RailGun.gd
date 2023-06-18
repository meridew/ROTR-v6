extends Node2D

var stats = Stats.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	name = 'RailGun'
	stats.add_stat()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
