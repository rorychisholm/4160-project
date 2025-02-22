extends Node

class_name SkeletonState

var enemy: CharacterBody2D
var state_machine: Node

func _ready() -> void:
	if state_machine == null:
		state_machine = get_parent()  # Automatically set state_machine if missing

func enter(_enemy):
	pass

func exit(_enemy):
	pass

func process_input(_enemy, _event):
	pass

func physics_update(_enemy, _delta):
	pass
