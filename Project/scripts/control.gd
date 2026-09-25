extends Control

func _on_play_button_pressed() -> void:
	Global.reset_run()
	get_tree().change_scene_to_file("res://scenes/level1.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_help_button_pressed() -> void:
	$HelpPanel.visible = true
	$VBoxContainer.visible = false
	$Title.visible = false

func _on_close_help_button_pressed() -> void:
	$HelpPanel.visible = false 
	$VBoxContainer.visible = true
	$Title.visible = true
