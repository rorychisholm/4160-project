extends SkeletonState

@export var flash_duration: float = 0.2  # Time for flashing red
@export var knockback_force: float = 200.0  # Push enemy when hit

# Called when the node enters the scene tree for the first time.
func enter(enemy):
	#print("Enemy is hurt!")
	
	enemy.velocity = Vector2.ZERO  # Stop movement
	enemy.get_node("AnimatedSprite2D").modulate = Color(1, 0, 0)  # Flash red
	enemy.get_node("HrtSFX").play()
	
	# Apply knockback (optional)
	var player = get_tree().get_first_node_in_group("player")  # Find player
	if player:
		print("Player position:", player.global_position)
		var direction = (enemy.global_position - player.global_position).normalized()
		enemy.velocity = direction * knockback_force  # Example: Knock enemy back from player
	
	await get_tree().create_timer(flash_duration).timeout
	enemy.get_node("AnimatedSprite2D").modulate = Color(1, 1, 1) # Restore original color
	state_machine.change_state(enemy.idle_state)  # Return to idle
	

func exit(enemy):
	enemy.velocity = Vector2.ZERO  # Reset movement when leaving state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
