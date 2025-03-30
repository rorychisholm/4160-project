extends Area2D

@onready var dialogue_box = $CanvasLayer/DialogueBox

func _on_body_entered(body):
	#When the player enters the trigger zone
	if body.name == "Player":
		print("Player instance found")
		body.toggle_input() #Stop accepting input
		body.velocity = Vector2.ZERO #stop movement
		show_dialogue() #Show dialogue box
		
func show_dialogue():
	if dialogue_box:
		dialogue_box.start_dialogue()
