extends Node2D

@onready var pause_menu := $PauseLayer/PauseUI/PauseMenu

#var _intro_shown := false

func _ready() -> void:
	pause_menu.visible = false
	if Global.easy_mode:
		Global.reset_run()
		
	Global.wind_active = false
	Global.on_ice = false

	if get_tree().current_scene.scene_file_path.ends_with("level2.tscn"):
		Global.wind_active = true
		Global.on_ice = true

func _process(_delta: float) -> void:
	pass

func _on_PauseButton_pressed() -> void:
	get_tree().paused = true
	pause_menu.visible = true

func _on_ResumeButton_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false

func _on_MainMenuButton_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	Global.reset_run()
	get_tree().change_scene_to_file("res://scenes/control.tscn")

func _on_back_button_pressed() -> void:
	$SettingsPanel.visible = false
	$PauseContent.visible = true
