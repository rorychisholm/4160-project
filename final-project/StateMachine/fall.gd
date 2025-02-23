extends State

class_name FallState

func enter(player):
	#print("Entered FallState")
	player.get_node("AnimatedSprite2D").animation = "fall"

func physics_update(player, delta: float):
	if player.is_on_floor():
		state_machine.change_state(player.idle_state)
