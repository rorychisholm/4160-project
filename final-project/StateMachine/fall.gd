extends State

class_name FallState

func enter(player):
	#print("Entered FallState")
	player.get_node("AnimatedSprite2D").animation = "fall"

func physics_update(player, _delta: float):
	#handle direction change when falling
	if player.can_move:
		if Input.is_action_pressed("move_right"):
			player.direction = +1
			player.flip_direction(false)
			player.velocity.x = player.direction * player.speed * 0.75
		elif Input.is_action_pressed("move_left"):
			player.direction = -1
			player.flip_direction(true)
			player.velocity.x = player.direction * player.speed * 0.75
		else:
			player.velocity.x = 0
	
	if player.is_on_floor():
		#handling player input when they land, what to do next
		player.get_node("LndSFX").play()
		if Input.is_action_just_pressed("basic_attack") and player.get_node("Stamina").expend(player.atk_stma) >= 0 and player.can_move:
			state_machine.change_state(player.attack_state)
		elif Input.is_action_just_pressed("roll") and player.get_node("Stamina").expend(player.rll_stma) >= 0 and player.can_move:
			state_machine.change_state(player.roll_state)
		elif Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left") and player.can_move:
			state_machine.change_state(player.run_state)
		elif Input.is_action_just_pressed("jump") and player.can_move:
			state_machine.change_state(player.jump_state)
		else:
			state_machine.change_state(player.idle_state)
