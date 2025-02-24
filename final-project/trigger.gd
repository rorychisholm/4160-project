extends Area2D

@onready var dialogue_box = $CanvasLayer/DialogueBox

func _on_body_entered(body):
	if body.name == "Player":
		print("Player instance found")
		body.toggle_input()
		show_dialogue()
		
func show_dialogue():
	if dialogue_box:
		dialogue_box.start_dialogue()
