extends Area2D

@export var boss_scene: PackedScene
@onready var spawn_point = $Marker2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		call_deferred("spawn_boss")

func spawn_boss():
	var boss_instance = boss_scene.instantiate() #create a bat instace
	get_parent().add_child(boss_instance) #add the bat to the scene
	boss_instance.global_position = spawn_point.global_position #set the position to the marker2d spawn point
	get_parent().get_node("WallBlock/CollisionShape2D").disabled = false
	queue_free() #delete the trigger after entering as to not re-trigger
