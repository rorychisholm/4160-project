extends CharacterBody2D

@export var speed = 400
@export var gravity = 980

func _on_health_health_empty() -> void:
	$AnimatedSprite2D.play("Death")
	$AnimatedSprite2D.connect("animation_finished", Callable(self, "_on_death_animation_finished"))
	
func _on_death_animation_finished() -> void:
	# Remove the character after the death animation finishes
	queue_free()

func _ready():
	$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("idle")
	

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
