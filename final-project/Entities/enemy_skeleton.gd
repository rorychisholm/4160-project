extends CharacterBody2D

@export var speed = 250
@export var gravity = 980
@export var attack_range: float = 80.0
@export var detection_range: float = 300.0

@onready var state_machine = $StateMachine
@onready var health_node = $Health
@onready var animated_sprite = $AnimatedSprite2D

var player: CharacterBody2D = null

func _ready():
	if not state_machine:
		print("❌ Error: StateMachine node not found!")
		return
	
	animated_sprite.play()
	state_machine.change_state(idle_state)
	
	if health_node:
		health_node.connect("health_empty", Callable(self, "_on_health_empty"))

func _on_health_empty() -> void:
	print("Health is empty, transitioning to death state...")
	state_machine.change_state("Death")

func play_animation(animation_name: String):
	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)

func _physics_process(delta):
	apply_gravity(delta)
	find_player()
	
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance > detection_range:
			state_machine.change_state("Idle")
		elif distance <= attack_range:
			state_machine.change_state("Attack")
		else:
			state_machine.change_state("Run")
			move_towards_player(delta)

	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func find_player():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func move_towards_player(delta):
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		velocity.y = 0
		animated_sprite.flip_h = velocity.x < 0
