extends State

class_name JumpState

func enter(player):
	#print("Entered JumpState")
	player.velocity.y = player.jump_strength
	player.get_node("AnimatedSprite2D").animation = "jump"

func physics_update(player, delta: float):
	if player.velocity.y >= 0:
		state_machine.change_state(player.fall_state)
