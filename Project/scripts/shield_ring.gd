extends Node2D

var active := false
var pulse_time := 0.0

func start() -> void:
	active = true
	visible = true

func stop() -> void:
	active = false
	visible = false

func _process(delta: float) -> void:
	if not active:
		return
	pulse_time += delta
	queue_redraw()

func _draw() -> void:
	if not active:
		return
	# Radius pulses gently between 13 and 15
	var radius = 14.0 + sin(pulse_time * 3.0) * 1.5
	# Outer glow ring (soft, slightly larger)
	draw_arc(Vector2.ZERO, radius + 2, 0, TAU, 32,
		Color(0.4, 0.7, 1.0, 0.25), 3.0)
	# Main ring
	draw_arc(Vector2.ZERO, radius, 0, TAU, 32,
		Color(0.5, 0.8, 1.0, 0.9), 1.5)
