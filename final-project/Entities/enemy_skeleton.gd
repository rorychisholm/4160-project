extends CharacterBody2D

@export var speed = 400
@export var gravity = 980
@export var attack_range: float = 20.0
@export var detection_range: float = 100.0

@onready var state_machine = $StateMachine

@onready var idle_state = $StateMachine/IdleState
@onready var run_state = $StateMachine/RunState
@onready var attack_state = $StateMachine/AttackState
@onready var death_state = $StateMachine/DeathState

func _ready():
	# Assign dynamically if not set in Inspector
	if state_machine == null:
		state_machine = get_node_or_null(state_machine)

	if state_machine:
		$AnimatedSprite2D.play()
		state_machine.change_state(idle_state)  # Ensure initial state setup
	else:
		print("❌ Error: StateMachine node not found!")

func _on_health_health_empty() -> void:
	state_machine.change_state(death_state)
	
func play_death_animation():
		$AnimatedSprite2D.play("Death")
		$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_death_animation_finished"))

func _on_death_animation_finished() -> void:
	# Remove the character after the death animation finishes
	queue_free()

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
