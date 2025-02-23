extends State

class_name AttackState

func enter(player):
	#print("Entered AttackState")
	
	player.velocity.x = 0
	
	# Play attack animation and enable hitbox
	player.get_node("AnimatedSprite2D").animation = "attack"
	var hitbox = player.get_node("BasicAttack/CollisionShape2D")
	hitbox.disabled = false

	# Wait for animation to finish before transitioning (non-blocking)
	player.get_node("AnimatedSprite2D").animation_finished.connect(_on_animation_finished.bind(player), CONNECT_ONE_SHOT)

func exit(player):
	# Disable hitbox when exiting attack state
	var hitbox = player.get_node("BasicAttack/CollisionShape2D")
	hitbox.disabled = true

func _on_animation_finished(player):
	if state_machine:
		state_machine.change_state(player.idle_state)
		player.get_node("AnimatedSprite2D").play()
