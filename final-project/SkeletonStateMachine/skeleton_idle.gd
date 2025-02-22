extends SkeletonState

func enter(enemy):
	if enemy == null:
		enemy = get_parent().get_parent()
	
	enemy.velocity = Vector2.ZERO
	enemy.get_node("AnimatedSprite2D").animation = "Idle"

func physics_process(enemy, _delta):
	if enemy.player and enemy.global_position.distance_to(enemy.player.global_position) <= enemy.detection_range:
		get_parent().change_state("Run")
