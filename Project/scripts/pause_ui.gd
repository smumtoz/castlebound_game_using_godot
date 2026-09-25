extends Control

@onready var pause_content: Control = $PauseContent
@onready var settings_panel: Control = $SettingsFree/SettingsPanel
@onready var level_name_label = $LevelNameLabel
@onready var difficulty_button: Button = %DifficultyButton
@onready var difficulty_value_label: Label = %DifficultyValueLabel

var current_level_name: String = "Level 1: The Fallen Meadows"
const MIN_DB := -60.0

func _debug_list_settings() -> void:
	var root := get_node_or_null("SettingsFree")
	if root == null:
		return

	
	for c in root.get_children():
		print(" - ", c.name)

	var panel := get_node_or_null("SettingsFree/SettingsPanel")
	
	if panel == null:
		return

	for c in panel.get_children():
		print(" - ", c.name)


func _ready() -> void:
	visible = false
	settings_panel.visible = false
	pause_content.visible = true

func _on_PauseButton_pressed() -> void:
	get_tree().paused = true
	visible = true

func _on_ResumeButton_pressed() -> void:
	get_tree().paused = true
	visible = false

func _on_MainMenuButton_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file("res://scenes/control.tscn")

func _on_settings_button_pressed() -> void:
	pause_content.visible = false
	settings_panel.visible = true
	level_name_label.text = "Settings"
	_debug_list_settings()

	difficulty_button.button_pressed = not Global.easy_mode
	difficulty_value_label.text = "Easy" if Global.easy_mode else "Hard"

func _on_back_button_pressed() -> void:
	settings_panel.visible = false
	pause_content.visible = true
	level_name_label.text = current_level_name


func _on_music_slider_value_changed(value: float) -> void:
	var bus: int = AudioServer.get_bus_index("Music")

	if value <= 0.001:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		var db: float = MIN_DB + (0.0 - MIN_DB) * value
		AudioServer.set_bus_volume_db(bus, db)


func _on_sfx_slider_value_changed(value: float) -> void:
	var bus: int = AudioServer.get_bus_index("SFX")

	if value <= 0.001:
		AudioServer.set_bus_mute(bus, true)
	else:
		AudioServer.set_bus_mute(bus, false)
		var db: float = MIN_DB + (0.0 - MIN_DB) * value
		AudioServer.set_bus_volume_db(bus, db)


func _on_difficulty_button_toggled(pressed: bool) -> void:
	# pressed = true means Hard
	Global.easy_mode = not pressed

	if Global.easy_mode:
		Global.health = 3
		Global.max_health = 3
		difficulty_value_label.text = "Easy"
	else:
		Global.health = 1
		Global.max_health = 1
		difficulty_value_label.text = "Hard"
	
	
	var hearts = get_tree().current_scene.get_node("PauseLayer/TopLeftUI/HeartsUI")
	#if hearts:
		#hearts._update_visibility()
		
func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	Global.reset_run()
	get_tree().reload_current_scene()
