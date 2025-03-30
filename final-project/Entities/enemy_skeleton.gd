extends CharacterBody2D

@export var speed = 250
@export var gravity = 980
@export var attack_range: float = 80.0
@export var detection_range: float = 300.0

@onready var state_machine = $StateMachine

@onready var idle_state = $StateMachine/IdleState
@onready var run_state = $StateMachine/RunState
@onready var attack_state = $StateMachine/AttackState
@onready var death_state = $StateMachine/DeathState
@onready var hurt_state = $StateMachine/HurtState

@onready var health_node = $Health

var player: CharacterBody2D = null

func _ready():
	# Assign dynamically if not set in Inspector
	if state_machine == null:
		state_machine = get_node_or_null(state_machine)

	if state_machine:
		$AnimatedSprite2D.play()
		state_machine.change_state(idle_state)  # Ensure initial state setup
	else:
		print("❌ Error: StateMachine node not found!")
		

func _on_health_empty() -> void:
	print("Health is empty, transitioning to death state...")
	state_machine.change_state(death_state)
	
func play_death_animation():
	if not $AnimatedSprite2D.animation_finished.is_connected(_on_death_animation_finished):
		$DthSFX.play()
		$AnimatedSprite2D.play("Death")
		$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_death_animation_finished"))

func _on_death_animation_finished() -> void:
	# Remove the character after the death animation finishes
	queue_free()

func _physics_process(delta):
	find_player()
	#logic for deciding whether to be in attack state or idle state
	#if they are in range, attack, else idle animation
	
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if distance > detection_range:
			state_machine.change_state(idle_state)
		elif distance <= attack_range:
			state_machine.change_state(attack_state)
		else:
			state_machine.change_state(run_state)
			move_towards_player(delta)
	# Apply gravity if enemy isnt on floor
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func find_player():
	#logic for finding the player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player

func move_towards_player(_delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		if is_on_floor():  #only reset Y velocity if on the ground
			velocity.y = 0 #makes sure they don't start flying up at the player
		# Flip the sprite based on the direction of movement
		if velocity.x > 0:
			flip_direction(false)  # Flip sprite to face right (default)
		elif velocity.x < 0:
			flip_direction(true)  # Flip sprite to face left (towards player)
			
func flip_direction(is_left: bool):
	#method for changing the direction of the hitboxes and hurtboxes attached to the enemy
	var hitbox = $CollisionShape2D
	var attack_hitbox = $AttackBox
	var hurtbox = $HurtBox
	var enemy_offset: float = -2  # Adjust based on hitbox size
	var attack_offset: float = 27
	var direction = -1 if is_left else 1
	
	if not is_left: #if right
		enemy_offset = -10
		attack_offset = 17
	
	$AnimatedSprite2D.flip_h = is_left
	hitbox.position.x = direction * enemy_offset
	hurtbox.position.x = direction * enemy_offset
	attack_hitbox.position.x = direction * attack_offset
