extends CharacterBody2D


#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0

func _ready():
	var root = get_tree().current_scene
	if root and root.name == "IntroLevel":
		var sprite = $AnimatedSprite2D
		sprite.flip_h = true #make him face the player
		sprite.play() #play the animation

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
