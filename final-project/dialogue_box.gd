extends Control

var dialogue_data = {
	1:{"speaker": "Player", "dialogue": "You... You're not the princess?"},
	2:{"speaker": "???", "dialogue": "It seems your princess is in another castle."},
	3:{"speaker": "???", "dialogue": "Good luck getting back to her from alllll the way down there"},
	4:{"speaker": "Player", "dialogue": "What?!"}
}

var current_index = 1

func start_dialogue():
	if not visible:
		visible = true
	if current_index in dialogue_data:
		var entry = dialogue_data[current_index]
		$Speaker.text = entry["speaker"]  # Update speaker name
		$Dialogue.text = entry["dialogue"]  # Update dialogue text
		

func _on_button_pressed() -> void:
	current_index += 1
	if current_index in dialogue_data:
		start_dialogue()
	else:
		get_parent().get_parent().get_node("CollisionShape2D").disabled = true
		visible = false
		var circle = get_parent().get_parent().get_parent().get_node("circle")
		circle.visible = true
		await get_tree().create_timer(2).timeout
		get_tree().get_nodes_in_group("player")[0].can_move = true
		get_tree().change_scene_to_file("res://Scenes/limbo.tscn")
