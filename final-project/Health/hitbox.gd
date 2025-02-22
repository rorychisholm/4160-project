class_name HitBox
extends Area2D

#HITBOX IS ASSOCIATEDWITH ATTACKS, DEALING THE DAMAGE

@export var damage: int = 1 : set = set_damage, get = get_damage

func set_damage(value: int):
	damage = value
	
func get_damage() -> int:
	return damage
