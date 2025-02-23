extends SkeletonState

func enter(enemy):
	print("Enemy in Death State")
	enemy.velocity = Vector2.ZERO
	enemy.play_death_animation()
