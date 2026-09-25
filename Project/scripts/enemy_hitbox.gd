extends Area2D

@onready var cooldown_timer: Timer = $CoolDownTimer

func _ready() -> void:
	cooldown_timer.one_shot = true

func _on_body_entered(body: Node) -> void:
	if not monitoring:
		return
	if not body.is_in_group("Player"):
		return

	if body.has_method("take_enemy_hit"):
		body.take_enemy_hit(global_position.x)

	# disable hitbox briefly (deferred to avoid physics signal error)
	set_deferred("monitoring", false)
	cooldown_timer.start()

func _on_cool_down_timer_timeout() -> void:
	set_deferred("monitoring", true)
