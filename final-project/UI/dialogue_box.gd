extends Control

var dialogue_data = { #dictionary to store dialogue
	1:{"speaker": "Player", "dialogue": "You... You're not the princess?"},
	2:{"speaker": "???", "dialogue": "It seems your princess is in another castle."},
	3:{"speaker": "???", "dialogue": "Good luck getting back to her from alllll the way down there"},
	4:{"speaker": "Player", "dialogue": "What?!"}
}

var current_index = 1 #start of the dialogue

func start_dialogue():
	if not visible:
		visible = true
	if current_index in dialogue_data:
		var entry = dialogue_data[current_index]
		$Speaker.text = entry["speaker"]  # Update speaker name
		$Dialogue.text = entry["dialogue"]  # Update dialogue text
		

func _on_button_pressed() -> void:
	current_index += 1 #step through the dialogue dictionary
	if current_index in dialogue_data:
		start_dialogue()
	else:
		#if the dialogue has finished...
		get_parent().get_parent().get_node("CollisionShape2D").disabled = true #remove the collision box as to not retrigger
		visible = false #turn off the dialogue box
		var circle = get_parent().get_parent().get_parent().get_node("circle") 
		circle.visible = true #spawn the demon circle
		get_parent().get_parent().get_parent().get_node("PrtlSFX").play()
		await get_tree().create_timer(2).timeout #timer before teleportation
		get_tree().get_nodes_in_group("player")[0].can_move = true
		get_tree().change_scene_to_file("res://Scenes/limbo.tscn") #move player to new scene

func _on_visibility_changed(): #when the dialogue box becomes visible, grab focus on the button
	if visible:
		$Button.grab_focus()
