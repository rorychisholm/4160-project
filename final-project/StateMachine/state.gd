extends Node

class_name State

var player: CharacterBody2D
var state_machine: Node
func _ready():
	if state_machine == null:
		state_machine = get_parent()  # Automatically set state_machine if missing

func enter(_player):
	pass

func exit(_player):
	pass

func process_input(_player, _event):
	pass

func physics_update(_player, _delta):
	pass
