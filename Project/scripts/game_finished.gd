extends Node2D
@export var level_title: String = ""
@export var narrative_text: String = ""
@onready var sprite = $CastleSprite
@onready var game_manager = get_tree().current_scene.get_node("Game Manager")
var changing := false
var castle_visited := false
var time := 0.0
const COMPLETE_SCENE = preload("res://scenes/complete.tscn")

func _process(delta):
	time += delta
	var scale_offset = sin(time * 3.0) * 0.01
	sprite.scale = Vector2(1, 1) + Vector2(scale_offset, scale_offset)
	var glow = 0.08 * sin(time * 2.5)
	sprite.modulate = Color(1.0 + glow, 1.0 + glow, 1.0 + glow, 1.0)

func _on_trigger_area_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and not changing:
		if game_manager.key == 1:
			changing = true
			call_deferred("_go_complete")
		elif not castle_visited:
			changing = true
			castle_visited = true
			_delayed_warning()
		else:
			_show_fading_reminder()

func _delayed_warning() -> void:
	await get_tree().create_timer(0.8).timeout
	_show_no_key_warning()

func _show_no_key_warning() -> void:
	var overlay = get_tree().current_scene.get_node_or_null("PauseLayer/IntroOverlay")
	if not overlay:
		return
	var story = overlay.get_node_or_null("Control/VBoxContainer/StoryText")
	if story:
		story.text = "The gate will not open.\n\nThe key lies somewhere ahead.\nFind it and return."
	if not overlay.dismissed.is_connected(_on_overlay_dismissed):
		overlay.dismissed.connect(_on_overlay_dismissed)
	overlay.show_with_fade()

func _on_overlay_dismissed() -> void:
	changing = false

func _show_fading_reminder() -> void:
	var popup = get_tree().current_scene.get_node_or_null("PauseLayer/TopLeftUI/HeartsUI/KeyHintPopup")
	if not popup:
		return
	var label = popup.get_node_or_null("HintLabel")
	if label:
		label.text = "You must find the key!"
	popup.modulate.a = 0.0
	popup.visible = true
	var tween := create_tween()
	tween.tween_property(popup, "modulate:a", 1.0, 0.4)
	tween.tween_interval(3.0)
	tween.tween_property(popup, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): popup.visible = false)

func _on_reminder_zone_body_entered(body: Node) -> void:
	if body.is_in_group("Player") and castle_visited and game_manager.key == 0:
		var popup = get_tree().current_scene.get_node_or_null("PauseLayer/TopLeftUI/HeartsUI/KeyHintPopup")
		if not popup:
			return
		var label = popup.get_node_or_null("HintLabel")
		if label:
			label.text = "The key is past the castle!"
		popup.modulate.a = 0.0
		popup.visible = true
		var tween := create_tween()
		tween.tween_property(popup, "modulate:a", 1.0, 0.4)
		tween.tween_interval(3.0)
		tween.tween_property(popup, "modulate:a", 0.0, 0.5)
		tween.tween_callback(func(): popup.visible = false)

func _go_complete() -> void:
	var fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	get_tree().current_scene.add_child(fade)
	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.7)
	await tween.finished
	get_tree().change_scene_to_packed(COMPLETE_SCENE)
