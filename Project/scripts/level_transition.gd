extends Control

@export var next_level_path: String = "res://scenes/level2.tscn"
@export var level_title: String = ""
@export var narrative_text: String = ""

@onready var coins_label = $VBoxContainer/CoinsLabel
@onready var story_label = $VBoxContainer/StoryLabel
@onready var next_label = $VBoxContainer/NextLabel



func _ready():
	var gm = get_tree().current_scene.get_node_or_null("Game Manager")

	if gm:
		coins_label.text = "You found " + str(gm.score) + " coins"
	else:
		coins_label.text = "You found 0 coins"

	story_label.text = narrative_text
	next_label.text = "Next: " + level_title

	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.6)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var gm = get_tree().current_scene.get_node_or_null("Game Manager")
		if gm:
			gm.reset()

		get_tree().change_scene_to_file(next_level_path)
