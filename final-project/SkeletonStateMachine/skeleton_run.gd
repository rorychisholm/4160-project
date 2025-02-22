extends SkeletonState

func physics_process(enemy, delta):
	if enemy.player:
		var distance = enemy.global_position.distance_to(enemy.player.global_position)
		
		if distance > enemy.detection_range:
			get_parent().change_state("Idle")
		elif distance <= enemy.attack_range:
			get_parent().change_state("Attack")
		else:
			var direction = (enemy.player.global_position - enemy.global_position).normalized()
			enemy.velocity = direction * enemy.speed
			enemy.move_and_slide()
