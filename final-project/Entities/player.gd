extends CharacterBody2D

@export var speed = 400
@export var gravity = 980
@export var jump_strength = -500

@onready var state_machine = $StateMachine

@onready var idle_state = $StateMachine/IdleState
@onready var run_state = $StateMachine/RunState
@onready var jump_state = $StateMachine/JumpState
@onready var fall_state = $StateMachine/FallState
@onready var attack_state = $StateMachine/AttackState

func _ready():
	# Assign dynamically if not set in Inspector
	if state_machine == null:
		state_machine = get_node_or_null(state_machine)

	if state_machine:
		$AnimatedSprite2D.play()
		state_machine.change_state(idle_state)  # Ensure initial state setup
	else:
		print("❌ Error: StateMachine node not found!")
	

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func flip_direction(is_left: bool):
	var hitbox = $CollisionShape2D
	var attack_hitbox = $BasicAttack
	var player_offset: float = -10  # Adjust based on hitbox size
	var attack_offset: float = 50
	var direction = -1 if is_left else 1
	
	if not is_left:
		player_offset = -15
	
	$AnimatedSprite2D.flip_h = is_left
	hitbox.position.x = direction * player_offset
	attack_hitbox.position.x = direction * attack_offset
		
	
