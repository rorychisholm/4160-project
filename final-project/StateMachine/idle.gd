extends State

class_name IdleState

func enter(player):
	#print("Entered IdleState")
	player.velocity = Vector2.ZERO
	if (player.direction < 0):
		player.flip_direction(true)
	player.get_node("AnimatedSprite2D").animation = "stand"

func process_input(player, event: InputEvent):
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		state_machine.change_state(player.run_state)
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_state(player.jump_state)
	elif Input.is_action_just_pressed("basic_attack"):
		state_machine.change_state(player.attack_state)

func physics_update(player, delta: float):
	if not player.is_on_floor():
		state_machine.change_state(player.fall_state)
