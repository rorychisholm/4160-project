extends Control

func _on_start_button_pressed() -> void: #when start button pressed, navigate to the next scene
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")

func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")

func _on_quit_button_pressed() -> void: #quit the game on quit button pressed
	get_tree().quit()
