extends Area2D

@export var bat_scene: PackedScene
@onready var spawn_point = $Marker2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		call_deferred("spawn_bat")

func spawn_bat():
	var bat_instance = bat_scene.instantiate() #create a bat instace
	get_parent().add_child(bat_instance) #add the bat to the scene
	bat_instance.global_position = spawn_point.global_position #set the position to the marker2d spawn point
	bat_instance.add_to_group("bats")  # Add to "bats" group
	queue_free() #delete the trigger after entering as to not re-trigger
