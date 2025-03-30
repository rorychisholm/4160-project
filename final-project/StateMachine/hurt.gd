extends State

class_name HurtState

@export var hurt_duration: float = 0.5
var timer: Timer

func enter(player):
	player.velocity = Vector2.ZERO  # Stop movement
	player.get_node("AnimatedSprite2D").animation = "hurt"  # Play hurt animation
	player.get_node("HrtSFX").play()
	timer = Timer.new()
	timer.wait_time = hurt_duration
	timer.one_shot = true
	timer.timeout.connect(_on_animation_finished.bind(player))  # Correct connection
	player.add_child(timer)
	timer.start()
	player.get_node("AnimatedSprite2D").modulate = Color(1, 0.25, 0.25)  # Flash red

func exit(player):
	if timer:
		timer.queue_free()

func _on_animation_finished(player):
	player.get_node("AnimatedSprite2D").modulate = Color(1, 1, 1) # Restore original color
	if state_machine:
		if player.health.get_health() <= 0:
			state_machine.change_state(player.death_state)
		elif Input.is_action_just_pressed("basic_attack") and player.get_node("Stamina").expend(player.atk_stma) >= 0:
			state_machine.change_state(player.attack_state)
		elif Input.is_action_just_pressed("roll") and player.get_node("Stamina").expend(player.rll_stma) >= 0:
			state_machine.change_state(player.roll_state)
		elif Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			state_machine.change_state(player.run_state)
		elif Input.is_action_just_pressed("jump"):
			state_machine.change_state(player.jump_state)
		else:
			state_machine.change_state(player.idle_state)
		player.get_node("AnimatedSprite2D").play()
