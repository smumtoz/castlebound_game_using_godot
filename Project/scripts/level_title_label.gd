extends Label

@export var intro_line: String = ""
@export var level_title: String = ""
@export var intro_hold_time: float = 1.2
@export var title_hold_time: float = 2.0

func _ready():
	visible = true
	modulate.a = 0.0

	if intro_line != "":
		text = intro_line

		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 1.0, 0.5)
		tween.tween_interval(intro_hold_time)
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		tween.tween_callback(_show_title)
	else:
		_show_title()


func _show_title():
	text = level_title
	modulate.a = 0.0
	visible = true

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	tween.tween_interval(title_hold_time)
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	tween.tween_callback(_hide_label)


func _hide_label():
	visible = false
