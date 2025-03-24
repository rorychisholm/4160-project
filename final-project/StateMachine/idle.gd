extends State

class_name IdleState

func enter(player):
	print("Entered IdleState")
	player.velocity = Vector2.ZERO
	if (player.direction < 0):
		player.flip_direction(true)
	player.get_node("AnimatedSprite2D").animation = "stand"
	if not player.get_node("Health").is_connected("health_lowered", Callable(self, "enter_hurt_state")):
		player.get_node("Health").health_lowered.connect(enter_hurt_state)

func enter_hurt_state():
	state_machine.change_state(player.hurt_state)
	player.velocity.x = -1 * player.direction * 300  # Apply knockback

func process_input(player, _event: InputEvent):
	if player.can_move:
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			state_machine.change_state(player.run_state)
		elif Input.is_action_just_pressed("jump"):
			state_machine.change_state(player.jump_state)
		elif Input.is_action_just_pressed("basic_attack"):
			state_machine.change_state(player.attack_state)
		elif Input.is_action_just_pressed("roll"):
			state_machine.change_state(player.roll_state)

func physics_update(player, _delta: float):
	if not player.is_on_floor():
		state_machine.change_state(player.fall_state)
