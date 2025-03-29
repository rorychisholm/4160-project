extends State

class_name DeathState

@export var hurt_duration: float = 0.5

var timer: Timer

func enter(player):
	player.velocity = Vector2.ZERO  # Stop movement
	player.get_node("AnimatedSprite2D").animation = "death"  # Play hurt animation
	player.get_node("DthSFX").play()
	#player.get_node("HurtBox/CollisionShape2D").disabled = true
	timer = Timer.new()
	timer.wait_time = hurt_duration
	timer.one_shot = true
	timer.timeout.connect(_on_animation_finished.bind(player))  # Correct connection
	player.add_child(timer)
	timer.start()

func exit(_player):
	if timer:
		timer.queue_free()

func _on_animation_finished(_player):
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
