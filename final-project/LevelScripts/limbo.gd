extends Node2D

@onready var exit_label = $UI/ExitLabel

@export_range(0, 2000, 40) var linear_speed_max := 450.0: set = set_linear_speed_max
@export_range(0, 2000, 20) var linear_accel_max := 1000.0: set = set_linear_accel_max
@export_range(0, 5, 0.1) var predict_time := 1.0: set = set_predict_time

var pursuers: Array = []  # store all bats

var exit_requested = false
var exit_timer = 3.0 #how long they have to press again to exit
var time_left = 0.0

func _ready() -> void:
	exit_label.visible = false
	
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	
	refresh_bats()
	
func refresh_bats(): #this function made to run every frame to check if a new bat has spawned, 
					 #then it will call setup on the new bat
	pursuers = get_tree().get_nodes_in_group("bats")
	for bat in pursuers:
		bat.setup(predict_time, linear_speed_max, linear_accel_max)

func _process(delta: float) -> void:
	refresh_bats()
	if exit_requested:
		time_left -= delta
		if time_left <= 0:
			exit_requested = false
			exit_label.visible = false #hide message if time expires

func _input(event):
	if event.is_action_pressed("exit"):
		if exit_requested: #if the button is already clicked, then quit the game
			get_tree().quit()
		else: #otherwise request to exit the game
			request_exit()
			
func request_exit():
	exit_requested = true
	time_left = exit_timer
	exit_label.text = "Press {escape/start/menu} again to quit"
	exit_label.visible = true



# FUNCTIONS FOR BAT STEERING BEHAVIOURS
func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	for bat in pursuers:
		bat.agent.linear_speed_max = value


func set_linear_accel_max(value: float) -> void:
	linear_accel_max = value
	if not is_inside_tree():
		return

	for bat in pursuers:
		bat.agent.linear_acceleration_max = value


func set_predict_time(value: float) -> void:
	predict_time = value
	if not is_inside_tree():
		return

	for bat in pursuers:
		bat._behaviour.predict_time_max = value
