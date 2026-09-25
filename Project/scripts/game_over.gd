extends CanvasLayer

@onready var reason_label: Label = $Control/Panel/VBoxContainer/ReasonLabel

func show_game_over(cause: String) -> void:
	visible = true

	if cause == "fall":
		reason_label.text = "You fell into the abyss."
	elif cause == "enemy":
		reason_label.text = "You were struck down by an enemy."
	else:
		reason_label.text = "You have fallen."

	await get_tree().create_timer(1.5).timeout
	Global.health = 3
	get_tree().reload_current_scene()
