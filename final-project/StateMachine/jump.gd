extends State

class_name JumpState

func enter(player):
	#print("Entered JumpState")
	player.velocity.y = player.jump_strength
	player.get_node("AnimatedSprite2D").animation = "jump"

func physics_update(player, delta: float):
	if Input.is_action_pressed("move_right"):
		player.direction = +1
		player.flip_direction(false)
		player.velocity.x = player.direction * player.speed
	elif Input.is_action_pressed("move_left"):
		player.direction = -1
		player.flip_direction(true)
		player.velocity.x = player.direction * player.speed
	else:
		player.velocity.x = 0

	if player.velocity.y >= 0:
		state_machine.change_state(player.fall_state)
