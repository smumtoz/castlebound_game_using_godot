extends Node2D

var active := false
var duration := 8.0
var elapsed := 0.0
var bar_color := Color.YELLOW
const BAR_W := 20.0
const BAR_H := 3.0

func start(color: Color) -> void:
	active = true
	elapsed = 0.0
	bar_color = color
	visible = true

func stop() -> void:
	active = false
	visible = false

func _process(delta: float) -> void:
	if not active:
		return
	elapsed += delta
	if elapsed >= duration:
		stop()
		return
	queue_redraw()

func _draw() -> void:
	if not active:
		return
	var fill = clamp(1.0 - (elapsed / duration), 0.0, 1.0)
	# Background bar
	draw_rect(Rect2(-BAR_W / 2, -26, BAR_W, BAR_H), Color(0, 0, 0, 0.5))
	# Fill bar
	draw_rect(Rect2(-BAR_W / 2, -26, BAR_W * fill, BAR_H), bar_color)
