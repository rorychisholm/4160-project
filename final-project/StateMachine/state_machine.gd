extends Node

@export var initial_state: NodePath
var current_state: State
@onready var player = get_parent()  # Get reference to Player

func _ready():
# Assign state_machine to all child states
	for child in get_children():
		if child is State:
			child.state_machine = self  # Explicitly set state_machine in all states

	if get_child_count() > 0:
		current_state = get_child(0) # assumes that the first child is the default starting state
		if current_state:
			current_state.enter(owner) # owner refers to the player
		else:
			print("Error: No valid state found in StateMachine!")

func change_state(new_state: State):
	if current_state:
		current_state.exit(player)
	
	current_state = new_state
	current_state.player = player  # Assign player
	current_state.state_machine = self  # Assign state machine
	current_state.enter(player)

func _unhandled_input(event: InputEvent):
	if current_state:
		current_state.process_input(player, event)

func _physics_process(delta: float):
	if current_state:
		current_state.physics_update(player, delta)
