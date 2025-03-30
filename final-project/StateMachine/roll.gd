extends State

class_name RollState

@export var roll_speed: float = 300
@export var roll_duration: float = 0.9

var roll_timer: float = 0.0
var roll_direction: int = 1
var original_collision_mask

func enter(player):
	print("Entering Roll State")
	var hurtbox = player.get_node("HurtBox/CollisionShape2D")
	hurtbox.disabled = true
	roll_speed = 300
	roll_timer = roll_duration
	roll_direction = sign(player.velocity.x)
	if roll_direction == 0:
		roll_direction = player.direction
		
	player.velocity.x = roll_direction * roll_speed
	player.get_node("AnimatedSprite2D").animation = "roll"
	player.get_node("RllSFX").play()
	player.get_node("Health").set_temporary_immortality(roll_duration)
	
	#save original collision mask
	original_collision_mask = player.get_collision_mask()
	
	#set new collision mask removing enemies (layer 2)
	player.set_collision_mask(original_collision_mask & ~2)
	
func physics_update(_player, delta):
	roll_timer -= delta
	if roll_timer <= 0:
		if state_machine:
			if Input.is_action_just_pressed("basic_attack") and player.get_node("Stamina").expend(player.atk_stma) >= 0:
				state_machine.change_state(player.attack_state)
			elif Input.is_action_just_pressed("roll") and player.get_node("Stamina").expend(player.rll_stma) >= 0:
				state_machine.change_state(player.roll_state)
			elif Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
				state_machine.change_state(player.run_state)
			elif Input.is_action_just_pressed("jump"):
				state_machine.change_state(player.jump_state)
			else:
				state_machine.change_state(player.idle_state)
			player.get_node("AnimatedSprite2D").play()
		
	player.velocity.x = roll_direction * roll_speed
	
func process_inputs(_event: InputEvent):
	pass
	
func exit(player):
	player.velocity.x = 0
	roll_speed = 0
	player.set_collision_mask(original_collision_mask)
	var hurtbox = player.get_node("HurtBox/CollisionShape2D")
	hurtbox.disabled = false
	
