class_name Statuses

var statuses : Dictionary

func _init():
	self.statuses = {}

func add_status(name: String, value: float, duration: float):
	var status = Status.new(name, value, duration)
	self.statuses[name] = status
	self.set(name, status)

func get_status(name: String) -> Status:
	return self.statuses[name]

func _get(name):
	if self.statuses.has(name):
		return self.statuses[name]
	else:
		return null

func remove_status(name: String):
	self.statuses.erase(name)
	self.set(name, null) # remove the property

func update_statuses(delta: float):
	for status in self.statuses.values():
		status.update_status(delta)
		remove_expired_statuses()
		
func remove_expired_statuses():
	for status in statuses.values():
		if status.duration > 0 and status.is_expired():
			statuses.erase(status.name)

class Status:

	var name: String
	var duration: float
	var elapsed: float

	func _init(name: String, value: float, duration: float):
		self.name = name
		self.value = value
		self.duration = duration
		self.elapsed = 0.0

	func update_status(delta: float):
		elapsed += delta

	func is_expired() -> bool:
		return elapsed >= duration
