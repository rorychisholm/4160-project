extends State

class_name FallState

func enter(player):
	#print("Entered FallState")
	player.get_node("AnimatedSprite2D").animation = "fall"

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
	
	if player.is_on_floor():
		if Input.is_action_just_pressed("basic_attack"):
			state_machine.change_state(player.attack_state)
		elif Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			state_machine.change_state(player.run_state)
		elif Input.is_action_just_pressed("jump"):
			state_machine.change_state(player.jump_state)
		else:
			state_machine.change_state(player.idle_state)
