class_name Health
extends Node

signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_lowered
signal health_empty

@export var max_health: int = 3 : set = set_max_health, get = get_max_health
@onready var health: int = max_health : set = set_health , get = get_health

@export var immortality: bool = false
var immortality_timer: Timer = null

func take_damage(damage: int):
	set_health(health - damage)
	health_lowered.emit()

func set_max_health(value: int):
	var clamped_value = 1 if value <=0 else value #make it so max health cant be lower than 1
	if not clamped_value == max_health:
		var difference = clamped_value - max_health #gets the difference of us setting the max health
		max_health = value #set the max health
		max_health_changed.emit(difference)
		
		if health > max_health: #if health above max health. reset it to max value
			health = max_health

func get_max_health() -> int:
	return max_health

func set_health(value: int):
	if value < health and immortality: #if we are immortal and try to reduce health, do nothing
		return
		
	var clamped_value = clampi(value, 0, max_health) #clamp our health from 0 to max
	if not clamped_value == health: #if its not min or max health
		var difference = clamped_value - health #get the diff we setting
		health = value #set the health
		health_changed.emit()

func get_health() -> int:
	return health

func set_immortality(value: bool):
	immortality = value

func get_immortality():
	return immortality
	
func set_temporary_immortality(time: float):
	if immortality_timer == null: #if there isn't already one
		immortality_timer = Timer.new() #create a new timer
		immortality_timer.one_shot = true #we only want to use it once before it frees itself from memory
		add_child(immortality_timer) #add it as a child of our current object
	
	if immortality_timer.timeout.is_connected(set_immortality): #for reusing, check if there is a timer already connected
		immortality_timer.timeout.disconnect(set_immortality) #if true then disconnect it
		
	immortality_timer.set_wait_time(time) #set how long we want to be immortal
	immortality_timer.timeout.connect(set_immortality.bind(false)) #set the immortality to false when the timer runs out
	immortality = true #set immortality to true
	immortality_timer.start() #start the timer
