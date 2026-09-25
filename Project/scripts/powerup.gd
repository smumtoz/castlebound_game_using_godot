extends Area2D

enum Type { GRAPE, APPLE }

@export var type: Type = Type.GRAPE

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Bobbing animation
	var tween = create_tween().set_loops()
	tween.tween_property(sprite, "position:y", -5.0, 0.85)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position:y", 5.0, 0.85)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_body_entered(body: Node) -> void:
	print("body entered: ", body.name)
	if body.name != "Player":
		return

	match type:
		Type.GRAPE:
			body.activate_double_jump()
			if not Global.grape_hint_shown:
				Global.grape_hint_shown = true
				Global.grape_hint.emit()
		Type.APPLE:
			body.activate_shield()
			if not Global.apple_hint_shown:
				Global.apple_hint_shown = true
				Global.apple_hint.emit()
	# Hide sprite and disable collision immediately
	$Sprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	# Play sound then free
	$PickupSFX.play()
	await $PickupSFX.finished

	queue_free()
