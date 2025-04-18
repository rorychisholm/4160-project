extends Control

func _ready():
	#sets the scale mode and aspect (fixes a bug where it gets offset later when you die)
	get_window().content_scale_mode = 2
	get_window().content_scale_aspect = 1

func _on_start_button_pressed() -> void: #when start button pressed, navigate to the next scene
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")

func _on_controls_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")

func _on_quit_button_pressed() -> void: #quit the game on quit button pressed
	get_tree().quit()
