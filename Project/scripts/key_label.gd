extends TextureRect

@onready var game_manager = get_tree().current_scene.get_node("Game Manager")

func _ready():
	if game_manager:
		game_manager.key_pickup.connect(_on_key_picked)
		_on_key_picked(game_manager.key)

func _on_key_picked(key):
	visible=game_manager.key==1
