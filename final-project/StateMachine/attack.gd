extends State

class_name AttackState

func enter(player):
	#print("Entered AttackState")
	
	player.velocity.x = 0
	
	if (player.direction < 0):
		player.flip_direction(true)
	# Play attack animation and enable hitbox
	player.get_node("AnimatedSprite2D").animation = "attack"
	player.get_node("AtkSFX").play()
	call_deferred("toggle_hitbox")

	# Wait for animation to finish before transitioning (non-blocking)
	player.get_node("AnimatedSprite2D").animation_finished.connect(_on_animation_finished.bind(player), CONNECT_ONE_SHOT)

func exit(player):
	# Disable hitbox when exiting attack state
	call_deferred("toggle_hitbox")

func _on_animation_finished(player):
	if state_machine:
		#When the animation finishes, read the input of the user
		if Input.is_action_just_pressed("basic_attack") and player.get_node("Stamina").expend(player.atk_stma) >= 0:
			state_machine.change_state(player.attack_state)
		elif Input.is_action_just_pressed("roll") and player.get_node("Stamina").expend(player.rll_stma) >= 0:
			state_machine.change_state(player.roll_state)
		elif Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			state_machine.change_state(player.run_state)
		elif Input.is_action_just_pressed("jump"):
			state_machine.change_state(player.jump_state)
		else:
			state_machine.change_state(player.idle_state)
		player.get_node("AnimatedSprite2D").play()

func toggle_hitbox():
	var hitbox = player.get_node("BasicAttack/CollisionShape2D")
	if hitbox.disabled == true:
		hitbox.disabled = false
	else:
		hitbox.disabled = true
