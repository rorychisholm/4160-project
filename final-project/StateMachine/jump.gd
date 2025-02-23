extends State

class_name JumpState

func enter(player):
	#print("Entered JumpState")
	player.velocity.y = player.jump_strength
	player.get_node("AnimatedSprite2D").animation = "jump"

func physics_update(player, delta: float):
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
		player.flip_direction(false)
	if Input.is_action_pressed("move_left"):
		direction -= 1
		player.flip_direction(true)
	player.velocity.x = direction * player.speed  # Set horizontal velocity
	if player.velocity.y >= 0:
		state_machine.change_state(player.fall_state)
