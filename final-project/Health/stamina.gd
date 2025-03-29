class_name Stamina
extends Node

signal stamina_changed

@export var max_stamina: float = 100 : set = set_max_stamina, get = get_max_stamina
@onready var stamina: float = max_stamina : set = set_stamina , get = get_stamina

# This could be true only when the player is not sprinting, etc.
var can_regen_stamina: bool = true

func _process(delta: float) -> void:
	if can_regen_stamina:
		stamina += 20 * delta # val per second
		stamina = clamp(stamina, 0.0, max_stamina)
		stamina_changed.emit()
	
	
		
func expend(reduct: int) -> int:
	if (get_stamina() - reduct) <= 0:
		return -1
	else:
		set_stamina(get_stamina() - reduct)
		stamina_changed.emit()
		return 0
		


func set_max_stamina(value: float):
	var clamped_value = 1 if value <= 0 else value #make it so max stamina cant be lower than 1
	if not clamped_value == max_stamina:
		var difference = clamped_value - max_stamina #gets the difference of us setting the max stamina
		max_stamina = value #set the max stamina
		
		if get_stamina() > max_stamina: #if health above max health. reset it to max value
			set_stamina(max_stamina)

func get_max_stamina() -> float:
	return max_stamina

func set_stamina(value: float):
	var clamped_value = clamp(value, 0.0, max_stamina) #clamp our stamina from 0 to max
	if not clamped_value == stamina: #if its not min or max stamina
		var difference = clamped_value - stamina #get the diff we setting
		stamina = value #set the stamina
		stamina_changed.emit()

func get_stamina() -> float:
	return stamina
