class_name State

enum Type {
	IDLE,
	DEFAULT,
	CHARGE,
	LUNGE,
	CIRCLE,
	RETREAT,
	LINE
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
	var circle_distance = 100
	var circle_speed = 100.0
	var approach_speed = 0.5
	var fluctuation_frequency = 1.0
	var fluctuation_amplitude = 20.0
	var time = 0.0

	func behavior(delta):
		# Calculate the desired position around the player
		var angle = time * circle_speed
		var offset = Vector2(cos(angle), sin(angle)) * circle_distance
		var desired_position = mob.player.global_position + offset

		# Add fluctuation to the distance
		circle_distance += sin(time * fluctuation_frequency) * fluctuation_amplitude * delta

		# Calculate the direction towards the desired position
		var direction = desired_position - mob.global_position

		# The mob's speed is determined by its stats
		var speed = mob.stats.get_stat('speed').current_value * 5  # Increase speed by multiplying by 5

		# Clamp the speed to a maximum value
		var max_speed = 100.0
		speed = clamp(speed, 0.0, max_speed)

		# Calculate the acceleration (force) needed to move towards the player, taking into account the mob's mass
		var mass = mob.stats.get_stat('mass').current_value * 0.1  # Decrease mass by multiplying by 0.1
		var force = direction.normalized() * speed / mass

		# Add the force to the mob's velocity
		mob.intended_velocity += force * delta

		# Clamp the mob's velocity magnitude to the maximum speed
		mob.intended_velocity = mob.intended_velocity.normalized() * clamp(mob.intended_velocity.length(), 0.0, max_speed)

		# Set sprite direction
		mob.set_sprite(mob.intended_velocity)

		# Gradually approach the player
		circle_distance -= approach_speed * delta

		# Update time
		time += delta

class RetreatState extends State:
	var retreat_duration = 5.0
	var retreat_timer = 0.0

	func behavior(delta):
		retreat_timer += delta

		if retreat_timer < retreat_duration:
			var direction = mob.global_position - mob.player.global_position
			direction = direction.normalized() * mob.stats.speed.current_value
			mob.intended_velocity = direction
			mob.set_sprite(direction)
		else:
			retreat_timer = 0.0
			mob.change_state(State.Type.DEFAULT)
