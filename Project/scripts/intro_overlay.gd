extends CanvasLayer

signal dismissed

@onready var player = get_tree().get_first_node_in_group("Player")

func _ready():
	get_tree().paused = true
	if player:
		player.visible = false

func show_with_fade() -> void:
	get_tree().paused = true
	visible = true
	var control = get_node_or_null("Control")
	if control:
		control.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(control, "modulate:a", 1.0, 0.5)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		if player:
			player.visible = true
		visible = false
		emit_signal("dismissed")
