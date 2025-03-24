extends State

class_name RollState

@export var roll_speed: float = 300
@export var roll_duration: float = 0.9

var roll_timer: float = 0.0
var roll_direction: int = 1

func enter(player):
	print("Entering Roll State")
	roll_speed = 300
	roll_timer = roll_duration
	roll_direction = sign(player.velocity.x)
	if roll_direction == 0:
		roll_direction = player.direction
		
	player.velocity.x = roll_direction * roll_speed
	player.get_node("AnimatedSprite2D").animation = "roll"
	
	player.get_node("Health").set_temporary_immortality(roll_duration)
	
func physics_update(_player, delta):
	roll_timer -= delta
	if roll_timer <= 0:
		player.velocity.x = 0
		roll_speed = 0
		state_machine.change_state(player.idle_state)
		
	player.velocity.x = roll_direction * roll_speed
	
func process_inputs(_event: InputEvent):
	pass
	
func exit(player):
	print("Exiting Roll")
	player.velocity.x = 0
