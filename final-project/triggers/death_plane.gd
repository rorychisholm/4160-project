extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print(body.name, " Entered Death Plane")
	if body.name == "Player":
		body._on_health_empty() #kill the player
	elif body.is_in_group("skeletons"):
		body.queue_free() #kill the skeletons outright (it bugs trying to set their health to 0)00
