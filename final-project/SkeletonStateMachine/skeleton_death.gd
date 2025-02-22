extends SkeletonState

func enter(enemy):
	enemy.velocity = Vector2.ZERO
	enemy.play_death_animation()
	enemy.queue_free()  # Removes the enemy after death animation
