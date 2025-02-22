extends SkeletonState


func enter(enemy):
	enemy.velocity = Vector2.ZERO
	enemy.attack()

func physics_process(enemy, _delta):
	if enemy.player and enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		get_parent().change_state("Run")
