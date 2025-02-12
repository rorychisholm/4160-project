extends CharacterBody2D

@export var speed = 400 # How fast the player will move (pixels/sec).
@export var gravity = 980
@export var jump_strength = -500
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#left/right movement
	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction += 1
	if Input.is_action_pressed("move_left"):
		direction -= 1
		
	velocity.x = direction * speed  # Set horizontal velocity
	
	# Handle input with direct conditions
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_strength
		
	move_and_slide()
	
	#COMBAT
	if Input.is_action_pressed("basic_attack"): #THIS PROB DONT WORK //TODO look up keyframing
		$AnimatedSprite2D.animation = "basic_attack"
		$AnimatedSprite2D/BasicHitHitbox/CollisionShape2D.disabled = false
	
	# BASIC MOVEMENT ANIMATIONS
	$AnimatedSprite2D.play()
	if velocity.y < 0:  #Player is jumping
		$AnimatedSprite2D.animation = "jump"
	elif velocity.y > 0:  #Player is falling
		$AnimatedSprite2D.animation = "fall"
	elif direction != 0: #Player is running
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.animation = "run"
		$AnimatedSprite2D.flip_h = direction < 0
	else: #Player is standing
		$AnimatedSprite2D.animation = "stand"
		
		


func _on_BasicHitHitbox_area_entered(area: Area2D) -> void: #use this function for attacking other things (check if their hitbox is in this hitbox)
	pass # Replace with function body.
