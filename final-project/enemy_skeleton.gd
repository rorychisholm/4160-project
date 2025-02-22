extends CharacterBody2D

@export var speed = 400
@export var gravity = 980

func _on_health_health_empty() -> void:
	queue_free()

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
