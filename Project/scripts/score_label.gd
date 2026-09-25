extends Label

@onready var game_manager = get_tree().current_scene.get_node("Game Manager")

func _ready():
	if game_manager:
		game_manager.score_changed.connect(_on_score_changed)
		_on_score_changed(game_manager.score)

func _on_score_changed(new_score):
	text = "x " + str(new_score)
