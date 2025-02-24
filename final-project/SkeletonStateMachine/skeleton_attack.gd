extends SkeletonState


func enter(enemy):
	#print("Enemy in Attack State")
	if enemy.health_node and enemy.health_node.get_health() <= 0:
		state_machine.change_state(enemy.death_state)
	else:
		attack(enemy)

func physics_process(enemy, _delta):
	if enemy.player and enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		state_machine.change_state(enemy.run_state)

func attack(enemy):
	#print("Attacking the Player")
	enemy.velocity = Vector2.ZERO
	enemy.get_node("AnimatedSprite2D").animation = "Attack"
	var hitbox = enemy.get_node("AttackBox/CollisionShape2D")
	if enemy.get_node("AnimatedSprite2D").frame in [5, 6, 7]:
		hitbox.set_deferred("disabled", false)
	else:
		hitbox.set_deferred("disabled", true)
	enemy.get_node("AnimatedSprite2D").animation_finished.connect(_on_animation_finished.bind(enemy), CONNECT_ONE_SHOT)

func _on_animation_finished():
	if state_machine and enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		state_machine.change_state(enemy.run_state)

	
	
func exit(enemy):
	var hitbox = enemy.get_node("AttackBox/CollisionShape2D")
	hitbox.disabled = true
