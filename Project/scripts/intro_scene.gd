
extends Control

@onready var bg = $Background

var time := 0.0

func _ready():
	get_tree().paused = true

func _process(delta):
	time += delta
	bg.scroll_offset.x = sin(time * 0.3) * 25

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/level1.tscn")
