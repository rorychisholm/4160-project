extends SkeletonState

func enter(enemy):
	#print("Enemy in Attack State")
	if enemy.health_node and enemy.health_node.get_health() <= 0:
		state_machine.change_state(enemy.death_state)
	else:
		attack()

func physics_process(enemy, _delta):
	if enemy.player and enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		state_machine.change_state(enemy.run_state)

func attack():
	#print("Attacking the Player")
	enemy.velocity = Vector2.ZERO
	enemy.get_node("AnimatedSprite2D").animation = "Attack"
	var hitbox = enemy.get_node("AttackBox/CollisionShape2D")
	hitbox.disabled = false
	enemy.get_node("AnimatedSprite2D").animation_finished.connect(_on_animation_finished.bind(enemy), CONNECT_ONE_SHOT)

func _on_animation_finished():
	if state_machine and enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		state_machine.change_state(enemy.run_state)
		enemy.get_node("AnimatedSprite2D").play()
	
	
func exit(enemy):
	var hitbox = enemy.get_node("AttackBox/CollisionShape2D")
	hitbox.disabled = true
