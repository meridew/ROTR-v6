extends BasePlayer

func _ready():
	set_stats()

func _process(delta) -> void:
	stats.update_modifiers(delta)

func set_stats():
	stats.add_stat('speed',150)
	stats.add_stat('hp_max',100)
	stats.add_stat('hp',100)
