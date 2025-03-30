extends SkeletonState


func enter(enemy):
	#Entering attack state
	if enemy.health_node and enemy.health_node.get_health() <= 0:
		state_machine.change_state(enemy.death_state) #if they are trying to attack but have died, set death state
	else:
		attack(enemy)

func physics_process(enemy, _delta):
	if enemy.player and enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		#if the player is outside attack range, change to run state
		state_machine.change_state(enemy.run_state)

func attack(enemy):
	enemy.velocity = Vector2.ZERO
	enemy.get_node("AnimatedSprite2D").animation = "Attack" #play attack ani
	var hitbox = enemy.get_node("AttackBox/CollisionShape2D")
	if enemy.get_node("AnimatedSprite2D").frame in [5, 6, 7]:
		hitbox.set_deferred("disabled", false) #if they are in the range of frames, set enable hitbox after
	else:
		hitbox.set_deferred("disabled", true) #else disable to hotbox
	
	if not enemy.get_node("AnimatedSprite2D").animation_finished.is_connected(_on_animation_finished):
		enemy.get_node("AnimatedSprite2D").animation_finished.connect(_on_animation_finished)

func _on_animation_finished(): #when attack animation finished, go back to run state
	if state_machine and enemy.global_position.distance_to(enemy.player.global_position) > enemy.attack_range:
		state_machine.change_state(enemy.run_state)

	
	
func exit(enemy): #if they are leaving attack state, make sure the hitbox is disabled
	var hitbox = enemy.get_node("AttackBox/CollisionShape2D")
	hitbox.disabled = true
