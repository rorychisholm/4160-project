extends TextureProgressBar

@onready var character: CharacterBody2D = get_tree().get_current_scene().find_child("Player", true, false)
@onready var stamina = character.get_node("Stamina")

func _ready() -> void:
	max_value = stamina.max_stamina
	value = stamina.stamina
	stamina.stamina_changed.connect(_update_bar)

func _update_bar() -> void:
	value = stamina.get_stamina()
