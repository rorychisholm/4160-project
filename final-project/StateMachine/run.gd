extends State

class_name RunState

func enter(player):
	#print("Entered RunState")
	player.get_node("AnimatedSprite2D").animation = "run"

func process_input(player, _event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(player.jump_state)
	elif Input.is_action_just_pressed("basic_attack"):
		state_machine.change_state(player.attack_state)

func physics_update(player, _delta: float):
	if Input.is_action_pressed("move_right"):
		player.direction = +1
		player.flip_direction(false)
		player.velocity.x = player.direction * player.speed
	elif Input.is_action_pressed("move_left"):
		player.direction = -1
		player.flip_direction(true)
		player.velocity.x = player.direction * player.speed
	else:
		state_machine.change_state(player.idle_state)

	if not player.is_on_floor():
		state_machine.change_state(player.fall_state)
