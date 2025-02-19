extends State

class_name RunState

func enter(player):
	print("Entered RunState")
	player.get_node("AnimatedSprite2D").animation = "run"

func process_input(player, event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(player.jump_state)
	elif Input.is_action_just_pressed("basic_attack"):
		state_machine.change_state(player.attack_state)

func physics_update(player, delta: float):
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1
	player.velocity.x = direction * player.speed  # Set horizontal velocity
	if direction == 0:
		state_machine.change_state(player.idle_state)

	player.velocity.x = direction * player.speed
	player.get_node("AnimatedSprite2D").flip_h = direction < 0

	if not player.is_on_floor():
		state_machine.change_state(player.fall_state)
