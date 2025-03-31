extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var curr_health = body.health.get_health()
		body.health.set_health(curr_health + 3)
		queue_free()
