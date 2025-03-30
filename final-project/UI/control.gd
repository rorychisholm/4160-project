extends Control

func _ready() -> void:
	sync_animations()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/IntroLevel.tscn")

func sync_animations(): #this ensures all button animations play at the same time and are not alternating randomly
	var sprites = get_tree().get_nodes_in_group("animations")
	for sprite in sprites:
		sprite.frame = 0  # Reset to the first frame
		sprite.play("default")
