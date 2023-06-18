class_name Stats
	
var stats : Dictionary

func _init():
	self.stats = {}

func add_stat(name: String, base_value: float):
	var stat = Stat.new(name, base_value)
	self.stats[name] = stat
	self.set(name, stat)

func get_stat(name: String) -> Stat:
	return self.stats[name]

func _get(name):
	if self.stats.has(name):
		return self.stats[name]
	else:
		return null

func remove_stat(name: String):
	self.stats.erase(name)
	self.set(name, null) # remove the property

func update_modifiers(delta: float):
	for stat in self.stats.values():
		stat.update_modifier(delta)
		stat.remove_expired_modifiers()

class Stat:
	enum StatType {
		VALUE,
		PERCENTAGE
	}

	var name: String
	var base_value: float
	var current_value: float
	var modifiers: Dictionary = {}

	func _init(name: String, base_value: float):
		self.name = name
		self.base_value = base_value
		self.current_value = base_value

	func update_modifier(delta: float):
		for modifier in modifiers.values():
			modifier.elapsed += delta

	func get_modified_value() -> float:
		var modified_value = current_value
		for modifier in modifiers.values():
			if not modifier.is_expired():
				modified_value = modifier.apply_to(modified_value)
		return modified_value

	func upgrade_stat(value: float, stat_type: StatType):
		match stat_type:
			StatType.VALUE:
				current_value += value
			StatType.PERCENTAGE:
				current_value *= (1 + value)

	func add_modifier(type: StatType, value: float, duration: float):
		var modifier = StatModifier.new(type, value, duration)
		modifiers[modifier] = modifier

	func remove_expired_modifiers():
		for modifier in modifiers.values():
			if modifier.is_expired():
				modifiers.erase(modifier)

class StatModifier:
	var type: Stat.StatType
	var value: float
	var duration: float
	var elapsed: float

	func _init(type: Stat.StatType, value: float, duration: float):
		self.type = type
		self.value = value
		self.duration = duration
		self.elapsed = 0.0

	func is_expired() -> bool:
		return elapsed >= duration

	func apply_to(value: float):
		match type:
			Stat.StatType.VALUE:
				return value + self.value
			Stat.StatType.PERCENTAGE:
				return value * (1 + (self.value / 100.0))
