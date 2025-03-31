extends CharacterBody2D


@export var walk_speed := 40.0
@export var attack_chance := 0.2  # 20% chance to attack when decision happens
@export var decision_interval := 2.0  # seconds between decisions

var direction := 0  # -1 for left, 1 for right, 0 for idle
var is_attacking := false

@onready var atk_sprite := $Attack
@onready var idl_sprite := $Idle
@onready var decision_timer := Timer.new()

func _ready():
	idl_sprite.visible = true
	atk_sprite.visible = false
	idl_sprite.play("fly")
	
	atk_sprite.animation_finished.connect(_on_attack_finished)
	atk_sprite.frame_changed.connect(_on_attack_frame_changed)
	
	add_child(decision_timer)
	decision_timer.wait_time = decision_interval
	decision_timer.timeout.connect(_on_decide_next_action)
	decision_timer.start()

	_on_decide_next_action()

func _physics_process(delta):
	if is_attacking:
		velocity = Vector2.ZERO
		return
		
	velocity.x = direction * walk_speed
	velocity.y = 0
	move_and_slide() 
	
	
func _on_decide_next_action():
	if is_attacking:
		return

	var roll = randf()

	if roll < attack_chance:
		_start_attack()
	else:
		direction = [-1, 0, 1][randi() % 3]  # Left, Idle, or Right
		
func _on_attack_frame_changed():
	var frame = atk_sprite.frame
	var hitbox = $HitBox/CollisionShape2D
	
	if frame in [7, 8, 9]:
		hitbox.disabled = false
	else:
		hitbox.disabled = true


func _start_attack():
	is_attacking = true
	direction = 0
	idl_sprite.visible = false
	atk_sprite.visible = true
	atk_sprite.play("attack")

func _on_attack_finished():
	is_attacking = false
	idl_sprite.visible = true
	atk_sprite.visible = false
	idl_sprite.play("fly")
	_on_decide_next_action()
