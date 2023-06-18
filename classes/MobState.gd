class_name State

enum States {
	IDLE,
	DEFAULT,
	CHARGE,
	LUNGE
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
			mob.change_state(State.States.DEFAULT)

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
				mob.change_state(States.DEFAULT) # Pass state name as string
