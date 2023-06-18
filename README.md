# ROTR-v6
 
var state = "idle"
var idle_timer = 0
var chase_timer = 0

func _physics_process(delta):
	if state == "idle":
		idle_behavior(delta)
	elif state == "chase":
		chase_behavior(delta)

func idle_behavior(delta):
	idle_timer += delta
	if idle_timer > stats.idle_time.current_value:  # Idle for 2 seconds
		state = "chase"
		idle_timer = 0
	else:
		stats.speed.current_value = 0  # Stop the mob while idle

func chase_behavior(delta):
	chase_timer += delta
	if chase_timer > stats.chase_time.current_value:  # Chase for 5 seconds
		state = "idle"
		chase_timer = 0
	else:
		stats.speed.current_value = stats.speed.base_value # Set the mob's speed while chasing





###


func idle_behavior():
	stats.speed.current_value = 0  # Stop the mob while idle

var pre_charge_duration = 5
var charge_duration = 3
var post_charge_duration = 5
var pre_charge_timer = 0
var charge_timer = 0
var post_charge_timer = 0
var charge_speed = 300

func charge_behaviour(delta):
	stats.speed.set_stat(0)
	pre_charge_timer += delta
	if pre_charge_timer > pre_charge_duration:
		var player_global_position = Vector2(Global.player.global_position)
		set_target_position(player_global_position)
		stats.speed.current_value = charge_speed
		animated_sprite.set_speed_scale(3)
		charge_timer += delta
		if charge_timer > charge_duration:
			stats.speed.set_stat(0)
			animated_sprite.set_speed_scale(1)
			post_charge_timer += delta
			if post_charge_timer > post_charge_duration:
				post_charge_timer = 0
				set_target_position(null)
				stats.speed.reset_stat()
				state = "chase"
			else:
				stats.speed.current_value = 0
		else:
			stats.speed.current_value = charge_speed

func chase_behavior(delta):
	stats.speed.current_value = stats.speed.base_value # Set the mob's speed while chasing
	var chase_timer = 0
	chase_timer += delta
	if chase_timer > stats.chase_time.current_value:  # Chase for 5 seconds
		state = "idle"
		chase_timer = 0



######


Creating a finite state machine (FSM) for your BaseMob in Godot Engine is a great approach to manage different behaviors of the mob and transitions between these behaviors. The FSM makes your game logic simpler, easier to maintain, and more modular.

The states you mentioned seem to cover most scenarios you'd need for a basic enemy AI in a top-down 2D game:

DEFAULT: The mob constantly follows the player.
IDLE: The mob stops moving.
CHARGE: The mob pauses (becomes idle), charges towards the player rapidly, pauses again, then goes back to default behavior.
CIRCLE: The mob circles around the Global.player while slowly closing in for n seconds, then
LUNGE: The mob makes n amount of lunges towards and away from the player n amount of times, then Default
These states appear to be a good start for your BaseMob behavior. Here are a few things to consider when implementing these states:

Transitions: How and when should the mob change from one state to another? For example, should the mob start circling the player after charging? Or should it go back to the default state? You'll need to define these rules.

Parameters: The behavior in each state might be influenced by parameters such as the charge duration, the radius of the circle when the mob is circling, or the lunge distance. Consider exposing these parameters so you can tweak them in the editor.

Additional states: Depending on your game mechanics, you might need additional states. For instance, you may want a STUNNED state if the player can stun the mob, or a DEAD state if the mob can be killed.

Animations and sounds: Each state can trigger specific animations and sounds. This will make the mob more dynamic and engaging.

State exit and entry actions: When transitioning from one state to another, you might want to perform some actions. For example, when the mob goes from CHARGE to IDLE, you might want to play a skidding animation or sound.

To implement the FSM, you have several options:

Script-based FSM: You can create a script for the BaseMob where you use match statement to switch between states. Each state would be a function in the script.

Node-based FSM: You can create a node for each state, and each node would have a script defining the behavior in that state. You can switch between states by adding and removing nodes.

Plugin-based FSM: You can use a Godot plugin that provides a FSM framework. This can save time and make your code cleaner, but it adds a dependency.

Overall, your plan to implement a FSM for your BaseMob in Godot is a solid starting point. It's always best to start simple and gradually add complexity as needed.
