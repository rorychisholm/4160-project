extends Node2D

var exit_requested = false
var exit_timer = 3.0 #how long they have to press again to exit
var time_left = 0.0

@onready var exit_label = $UI/ExitLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
