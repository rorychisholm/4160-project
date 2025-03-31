extends Control


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/limbo.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
