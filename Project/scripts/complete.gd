extends Control

@onready var coins_label = $VBoxContainer/CoinsLabel

func _ready():
	coins_label.text = "You found " + str(Global.coins) + " coins"
	Global.reset_coins()

func _on_play_pressed() -> void:
	Global.reset_run()
	get_tree().change_scene_to_file("res://scenes/level1.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/control.tscn")
