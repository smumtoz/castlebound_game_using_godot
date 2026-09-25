extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body):
	if body.name == "Player":
		var gm = get_tree().current_scene.get_node("Game Manager")
		if gm:
			gm.add_point()
			Global.add_coin()
		animation_player.play("pickup")
