class Status:
	var name: String
	var duration: float
	var elapsed: float

	func _init(name: String, duration: float):
		self.name = name
		self.duration = duration
		self.elapsed = 0.0

	func update_time(delta: float):
		elapsed += delta

	func is_expired() -> bool:
		return elapsed >= duration
