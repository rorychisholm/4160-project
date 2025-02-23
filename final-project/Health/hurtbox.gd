class_name HurtBox
extends Area2D

#HURTBOX IS ASSOCIATED WITH THE CHARACTER, TAKING DAMAGE

signal received_damage(damage: int)

@export var health: Health
@onready var state_machine = get_parent().get_node("StateMachine")


func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as HitBox
	if hitbox != null:
		health.health -= hitbox.damage
		print(get_parent(), " Health: ", health.health)
		received_damage.emit(hitbox.damage)
		if health.health == 0:
			health.health_empty.emit()
		else:
			state_machine.change_state(state_machine.get_node("HurtState"))  # Use the node

	
