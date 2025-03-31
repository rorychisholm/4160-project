extends CharacterBody2D


@export var walk_speed := 40.0
@export var attack_chance := 0.2  # 20% chance to attack when decision happens
@export var decision_interval := 2.0  # seconds between decisions

var direction := 0  # -1 for left, 1 for right, 0 for idle
var is_attacking := false
var is_dead = false

@onready var atk_sprite := $Attack
@onready var idl_sprite := $Idle
@onready var dth_sprite := $Death
@onready var ncr_dth_sprite := $Necro_Death
@onready var decision_timer := Timer.new()

var player: CharacterBody2D = null

func _ready():
	idl_sprite.visible = true
	atk_sprite.visible = false
	dth_sprite.visible = false
	ncr_dth_sprite.visible = false
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
		
	_face_player()
	velocity.x = direction * walk_speed
	velocity.y = 0
	move_and_slide() 
	
func find_player():
	#logic for finding the player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]  # Assuming there's only one player
		
func _face_player():
	find_player()
	var direction = (player.global_position.x - global_position.x)
	if direction > 0:
		flip_direction(true)  # Flip sprite to face right (default)
	elif direction < 0:
		flip_direction(false)  # Flip sprite to face left (towards player)

func flip_direction(is_right: bool):
	#method for changing the direction of the hitboxes and hurtboxes attached to the enemy
	var hitbox = $CollisionShape2D
	var attack_hitbox = $AttackBox
	var hurtbox = $HurtBox
	var enemy_offset: float = -2  # Adjust based on hitbox size
	var attack_offset: float = 27
	var direction = -1 if is_right else 1
	
	if not is_right: #if left
		enemy_offset = -10
		attack_offset = 17
	
	idl_sprite.flip_h = is_right
	atk_sprite.flip_h = is_right
	dth_sprite.flip_h = is_right
	ncr_dth_sprite.flip_h = is_right
	
	hitbox.position.x = direction * enemy_offset
	hurtbox.position.x = direction * enemy_offset

	
func _on_decide_next_action():
	if is_dead:
		return
	
	if $Health.health <= 0:
		_death()
		return
		
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
	if frame in [6]:
		$AtkSFX.play()
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

func _death():
	if is_dead:
		return
	is_dead = true

	idl_sprite.visible = false
	atk_sprite.visible = false
	dth_sprite.visible = true
	ncr_dth_sprite.visible = true
	dth_sprite.play("death")
	dth_sprite.modulate = Color(1, 0, 0, 1)
	$DthSFX.play()

	set_physics_process(false)
	$CollisionShape2D.disabled = true
	$HitBox.set_deferred("monitoring", false)

	await dth_sprite.animation_finished
	
	var tween = create_tween()
	tween.tween_property(dth_sprite, "modulate", Color(1, 0, 0, 0), 1.0)
	await tween.finished
	
	ncr_dth_sprite.play()
	await ncr_dth_sprite.animation_finished
	var boss_defeat_timer = get_node("/root/Limbo/BossDefeatTimer")
	boss_defeat_timer.start()
	queue_free()
