extends SkeletonState

func enter(enemy):
	if enemy.health_node and enemy.health_node.get_health() <= 0:
		state_machine.change_state(enemy.death_state)
	else:
		enemy.get_node("AnimatedSprite2D").animation = "Run"
	
	

func physics_process(enemy, _delta):
	if enemy.player:
		#if a player is found, determine if they are in attack range or out of detection range
		var distance = enemy.global_position.distance_to(enemy.player.global_position)
		
		if distance > enemy.detection_range:
			get_parent().change_state("Idle")
		elif distance <= enemy.attack_range:
			get_parent().change_state("Attack")
		else:
			var direction = (enemy.player.global_position - enemy.global_position).normalized()
			enemy.velocity.x = direction * enemy.speed
			enemy.move_and_slide()
