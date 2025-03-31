extends CharacterBody2D

@export var speed = 400
@export var gravity = 980
@export var jump_strength = -600
@export var direction = +1;

@export var atk_stma = 40 # attack stamina use
@export var rll_stma = 50 # roll atamia use

@onready var agent := GSAISteeringAgent.new() #variable for the bat enemies to track player

@onready var state_machine = $StateMachine
@onready var idle_state = $StateMachine/IdleState
@onready var run_state = $StateMachine/RunState
@onready var jump_state = $StateMachine/JumpState
@onready var fall_state = $StateMachine/FallState
@onready var attack_state = $StateMachine/AttackState
@onready var hurt_state = $StateMachine/HurtState
@onready var death_state = $StateMachine/DeathState
@onready var roll_state = $StateMachine/RollState

@onready var health

var can_move: bool = true
var alive: bool = true

func _ready():
	health = $Health
	if health == null:
		print("Error, health node missing in player scene!")

	if state_machine == null:
		state_machine = get_node_or_null(state_machine)

	if state_machine:
		$AnimatedSprite2D.play()
		state_machine.change_state(idle_state)  # Ensure initial state setup
	else:
		print("❌ Error: StateMachine node not found!")


func _on_health_empty() -> void:
	print("PLAYER HAS DIED")
	state_machine.change_state(death_state)

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	_update_agent()
	move_and_slide()

func flip_direction(is_left: bool):
	#logic for flipping the direction of the player's hitboxes and hurtboxes when they change direction
	var hitbox = $CollisionShape2D
	var attack_hitbox = $BasicAttack
	var hurtbox = $HurtBox
	var player_offset: float = -10  # Adjust based on hitbox size
	var attack_offset: float = 50
	direction = -1 if is_left else 1
	
	if not is_left:
		player_offset = -15
	
	$AnimatedSprite2D.flip_h = is_left
	hitbox.position.x = direction * player_offset
	hurtbox.position.x = direction * player_offset
	attack_hitbox.position.x = direction * attack_offset
	
func toggle_input():
	#method for stopping input detection so player cannot do anything (used in cutscenes)
	can_move = false if can_move == true else true
	velocity = Vector2.ZERO
	state_machine.change_state(idle_state)
	
func _update_agent() -> void: #method for the bat to track the player, updating the player (agent)'s location
	agent.position.x = global_position.x
	agent.position.y = global_position.y
