extends Node2D

enum WaveType {LINE, CIRCLE, GRID}
var current_wave = 0
var waves = [
	{type = WaveType.LINE, count = 5},
	{type = WaveType.CIRCLE, count = 10},
	{type = WaveType.GRID, count = 16},
]

# Here you can set the scene of the enemy to spawn
export PackedScene var Enemy

# Array to store the positions of the enemies
var positions := []

func _ready() -> void:
	positions = get_next_wave_positions()

# This function is called every time you want to spawn a new wave
func spawn_wave() -> void:
	for position in positions:
		spawn_enemy(position)
	positions = get_next_wave_positions()

# This function creates an instance of the enemy at a given position
func spawn_enemy(position: Vector2) -> void:
	var enemy = Enemy.instance()
	enemy.position = position
	add_child(enemy)

# The following functions are same as before
func get_next_wave_positions() -> Array:
	var wave = waves[current_wave]
	var positions = match wave.type:
		WaveType.LINE:
			get_line_positions(wave.count)
		WaveType.CIRCLE:
			get_circle_positions(wave.count)
		WaveType.GRID:
			get_grid_positions(wave.count)
	current_wave = (current_wave + 1) % waves.size()
	return positions

func get_line_positions(count: int) -> Array:
	var positions: Array = []
	for i in range(count):
		positions.append(Vector2(i * 100, 0))
	return positions

func get_circle_positions(count: int) -> Array:
	var positions: Array = []
	for i in range(count):
		var angle = i * 2 * PI / count
		var position = Vector2(cos(angle), sin(angle)) * 100
		positions.append(position)
	return positions

func get_grid_positions(count: int) -> Array:
	var positions: Array = []
	var size = sqrt(count)
	for i in range(count):
		var x = i % size
		var y = i / size
		positions.append(Vector2(x, y) * 100)
	return positions
