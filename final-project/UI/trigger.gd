extends Area2D

@onready var dialogue_box = $CanvasLayer/DialogueBox

func _on_body_entered(body):
	#When the player enters the trigger zone
	if body.name == "Player":
		print("Player instance found")
		body.velocity = Vector2.ZERO #stop movement
		body.toggle_input() #Stop accepting input
		if body.is_on_floor() == false:
			body.velocity.y = 0 # Stop any vertical movement (jumping/falling)
		show_dialogue() #Show dialogue box
		
func show_dialogue():
	if dialogue_box:
		dialogue_box.start_dialogue()
