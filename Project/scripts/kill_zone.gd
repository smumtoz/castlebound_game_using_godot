extends Area2D

@onready var timer: Timer = $Timer

var fall_cooldown_active: bool = false
var debug_logs: bool = true


func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = 0.25


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("Player"):
		return

	_try_fall_damage(body)

func _on_body_exited(body: Node) -> void:
	if not body.is_in_group("Player"):
		return

	fall_cooldown_active = false


func _try_fall_damage(body: Node) -> void:
	if fall_cooldown_active:
		return

	fall_cooldown_active = true
	timer.start()

	if body.has_method("take_fall_damage"):
		body.take_fall_damage()
	else:
		call_deferred("_reload_level")


func _on_timer_timeout() -> void:
	fall_cooldown_active = false

	for body in get_overlapping_bodies():
		if body.is_in_group("Player") and Global.easy_mode:
			_try_fall_damage(body)
			break


func _reload_level() -> void:
	get_tree().reload_current_scene()
