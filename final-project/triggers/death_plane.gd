extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player entered Death Plane")
		body._on_health_empty() #kill the player
