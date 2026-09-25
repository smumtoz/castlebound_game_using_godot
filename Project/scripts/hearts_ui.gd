extends Control

@onready var heart1: TextureRect = $HeartsRow/Heart1
@onready var heart2: TextureRect = $HeartsRow/Heart2
@onready var heart3: TextureRect = $HeartsRow/Heart3
@onready var heart_gain_label: Label = $HeartGainLabel
@onready var coin_hint_popup: PanelContainer = $CoinHintPopup
@onready var grape_hint_popup: PanelContainer = $GrapeHintPopup
@onready var apple_hint_popup: PanelContainer = $AppleHintPopup
@onready var score_ui = get_parent().get_node("Score UI")
@onready var key_label: Label = get_node_or_null("KeyLabel")
@onready var key_hint_popup: PanelContainer = get_node_or_null("KeyHintPopup")
@onready var bonus_heart_label: Label = $BonusHeartLabel

var full_heart: Texture2D = preload("res://ui/full_heart.tres")
var empty_heart: Texture2D = preload("res://ui/empty_heart.tres")

var _label_origin: Vector2

func _ready() -> void:
	heart_gain_label.visible = false
	_label_origin = heart_gain_label.position
	coin_hint_popup.visible = false
	grape_hint_popup.visible = false
	apple_hint_popup.visible = false

	if key_label:
		key_label.visible = false
	if key_hint_popup:
		key_hint_popup.visible = false

	if not Global.heart_gained.is_connected(_on_heart_gained):
		Global.heart_gained.connect(_on_heart_gained)
	if not Global.first_coin_hint.is_connected(_on_first_coin_hint):
		Global.first_coin_hint.connect(_on_first_coin_hint)
	if not Global.grape_hint.is_connected(_on_grape_hint):
		Global.grape_hint.connect(_on_grape_hint)
	if not Global.apple_hint.is_connected(_on_apple_hint):
		Global.apple_hint.connect(_on_apple_hint)
	if not Global.key_collected.is_connected(_on_key_collected):
		Global.key_collected.connect(_on_key_collected)
	if not Global.bonus_heart_stored.is_connected(_on_bonus_heart_stored):
		Global.bonus_heart_stored.connect(_on_bonus_heart_stored)
	if not Global.bonus_heart_consumed.is_connected(_on_bonus_heart_consumed):
		Global.bonus_heart_consumed.connect(_on_bonus_heart_consumed)
	if not Global.key_zone_1.is_connected(_on_key_zone_1):
		Global.key_zone_1.connect(_on_key_zone_1)
	if not Global.key_zone_2.is_connected(_on_key_zone_2):
		Global.key_zone_2.connect(_on_key_zone_2)
	if not Global.key_zone_3.is_connected(_on_key_zone_3):
		Global.key_zone_3.connect(_on_key_zone_3)

func _on_bonus_heart_stored() -> void:
	bonus_heart_label.modulate = Color(1, 0.85, 0.1, 1.0)
	bonus_heart_label.visible = true
	var tween := create_tween()
	tween.tween_property(bonus_heart_label, "scale", Vector2(1.3, 1.3), 0.1)
	tween.tween_property(bonus_heart_label, "scale", Vector2(1.0, 1.0), 0.15)

func _on_bonus_heart_consumed() -> void:
	var tween := create_tween()
	tween.tween_property(bonus_heart_label, "modulate:a", 0.0, 0.4)
	tween.tween_callback(func(): bonus_heart_label.visible = false)

func _on_key_zone_1() -> void:
	_show_key_proximity_popup("You're far from the key... Turn back!")

func _on_key_zone_2() -> void:
	_show_key_proximity_popup("You're getting warmer... Keep going")

func _on_key_zone_3() -> void:
	_show_key_proximity_popup("The key is very close! Climb Higher!")

func _show_key_proximity_popup(message: String) -> void:
	if not key_hint_popup:
		return
	var label = key_hint_popup.get_node_or_null("HintLabel")
	if label:
		label.text = message
	key_hint_popup.modulate.a = 0.0
	key_hint_popup.visible = true
	var tween := create_tween()
	tween.tween_property(key_hint_popup, "modulate:a", 1.0, 0.4)
	tween.tween_interval(4.0)
	tween.tween_property(key_hint_popup, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): key_hint_popup.visible = false)

func _on_key_collected() -> void:
	if key_label:
		key_label.position = _label_origin + Vector2(40, 0)
		key_label.text = "🗝+"
		key_label.modulate = Color(1, 0.85, 0.1, 1.0)
		key_label.visible = true
		var tween := create_tween()
		tween.tween_property(key_label, "position:y", key_label.position.y - 24, 1.0)
		tween.parallel().tween_property(key_label, "modulate:a", 0.0, 1.0)
		tween.tween_callback(func(): key_label.visible = false)
	if key_hint_popup:
		_show_key_proximity_popup("You found the key! Make your way to the castle gates.")

func _on_grape_hint() -> void:
	_show_popup(grape_hint_popup)

func _on_apple_hint() -> void:
	_show_popup(apple_hint_popup)

func _show_popup(popup: PanelContainer) -> void:
	popup.modulate.a = 0.0
	popup.visible = true
	var tween := create_tween()
	tween.tween_property(popup, "modulate:a", 1.0, 0.4)
	tween.tween_interval(2.5)
	tween.tween_property(popup, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): popup.visible = false)

func _process(_delta: float) -> void:
	visible = true
	var hp := Global.health
	heart1.texture = full_heart if hp >= 1 else empty_heart
	heart2.texture = full_heart if hp >= 2 else empty_heart
	heart3.texture = full_heart if hp >= 3 else empty_heart
	heart2.visible = Global.easy_mode
	heart3.visible = Global.easy_mode

func _on_heart_gained() -> void:
	heart_gain_label.position = _label_origin
	heart_gain_label.modulate = Color(1, 0.35, 0.35, 1.0)
	heart_gain_label.text = "+1 ♥"
	heart_gain_label.visible = true

	var tween := create_tween()
	tween.tween_property(heart_gain_label, "position:y", _label_origin.y - 24, 0.7)
	tween.parallel().tween_property(heart_gain_label, "modulate:a", 0.0, 0.7)
	tween.tween_callback(func(): heart_gain_label.visible = false)

func _on_first_coin_hint() -> void:
	coin_hint_popup.modulate.a = 0.0
	coin_hint_popup.visible = true

	var tween := create_tween()
	tween.tween_property(coin_hint_popup, "modulate:a", 1.0, 0.4)
	tween.tween_interval(2.5)
	tween.tween_property(coin_hint_popup, "modulate:a", 0.0, 0.5)
	tween.tween_callback(func(): coin_hint_popup.visible = false)
