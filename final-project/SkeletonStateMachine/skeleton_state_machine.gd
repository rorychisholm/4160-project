extends Node

@export var initial_state: NodePath
var current_state: SkeletonState = null
@onready var enemy = get_parent()  # Get reference to Player

func _ready() -> void:
	for child in get_children():
		if child is SkeletonState:
			child.state_machine = self  # Explicitly set state_machine in all states

	if get_child_count() > 0:
		current_state = get_child(0) # assumes that the first child is the default starting state
		if current_state:
			current_state.enter(enemy) # owner refers to the player
		else:
			print("Error: No valid state found in StateMachine!")

func change_state(new_state: SkeletonState):
	#logic for changing states
	if current_state:
		current_state.exit(enemy)
	
	current_state = new_state
	current_state.enemy = enemy  # Assign enemy
	current_state.state_machine = self  # Assign state machine
	current_state.enter(enemy)
