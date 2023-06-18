class_name State

enum Type {
	IDLE,
	DEFAULT,
	CHARGE,
	LUNGE,
	CIRCLE
}

var mob

func _init(mob):
	self.mob = mob

func behavior(delta):
	pass

class IdleState extends State:
	func behavior(delta):
		mob.intended_velocity = Vector2.ZERO
		mob.set_sprite(Vector2.ZERO)

class DefaultState extends State:
	func behavior(delta):
		var direction = Vector2.ZERO
		if mob.player:
			direction = mob.player.global_position - mob.global_position
			direction = direction.normalized() * mob.stats.speed.current_value
			mob.intended_velocity = direction
			mob.set_sprite(direction)

class ChargeState extends State:
	var idle_duration = 5
	var charge_duration = 10
	var timer = 0

	func behavior(delta):
		timer += delta
		if timer < idle_duration:
			mob.intended_velocity = Vector2.ZERO
			mob.set_sprite(Vector2.ZERO)
		elif timer < idle_duration + charge_duration:
			var direction = mob.player.global_position - mob.global_position
			direction = direction.normalized() * mob.stats.speed.current_value * 2
			mob.intended_velocity = direction
			mob.set_sprite(direction)
		elif timer < 2 * idle_duration + charge_duration:
			mob.intended_velocity = Vector2.ZERO
			mob.set_sprite(Vector2.ZERO)
		else:
			timer = 0
			mob.change_state(State.Type.DEFAULT)

class LungeState extends State:
	var lunge_timer = 0
	var lunge_duration = 1
	var lunge_pause_duration = 1
	var lunge_count = 0
	var max_lunges = 5

	func behavior(delta):
		lunge_timer += delta
		if lunge_timer < lunge_duration:
			# Mob is lunging towards the player
			var direction = mob.player.global_position - mob.global_position
			direction = direction.normalized() * mob.stats.speed.current_value * 2
			mob.intended_velocity = direction
			mob.set_sprite(direction)
		elif lunge_timer < lunge_duration + lunge_pause_duration:
			# Mob is lunging away from the player
			var direction = mob.global_position - mob.player.global_position
			direction = direction.normalized() * mob.stats.speed.current_value * 2
			mob.intended_velocity = direction
			mob.set_sprite(direction)
		else:
			# The lunge is over, reset the timer and check the lunge count
			lunge_timer = 0
			lunge_count += 1
			if lunge_count >= max_lunges:
				lunge_count = 0
				mob.change_state(State.Type.DEFAULT) # Pass state name as string

class CircleState extends State:
	var circle_timer = 0
	var circle_duration = 100
	var radius = 1000
	var angle_speed = 1

	func behavior(delta):
		circle_timer += delta
		if circle_timer < circle_duration:
			# Compute a circling direction with gradually reducing radius
			var direction = (Global.player.global_position - Global.global_position).normalized()
			var perpendicular = Vector2(direction.y, -direction.x)
			var circling_point = Global.player.global_position + direction * radius + perpendicular.rotated(angle_speed * circle_timer) * radius
			direction = (circling_point - Global.global_position).normalized() * mob.stats.speed.current_value

			# Decrease the radius to move closer to the player
			radius -= mob.stats.speed.current_value * delta

			mob.intended_velocity = direction
			mob.set_sprite(direction)
		else:
			circle_timer = 0
			radius = 150
			mob.change_state(State.Type.DEFAULT)
