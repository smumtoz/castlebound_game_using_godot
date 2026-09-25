extends Area2D
@onready var animation_player = $AnimationPlayer
var zone1_triggered := false
var zone2_triggered := false
var zone3_triggered := false
var zone4_triggered := false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var gm = get_tree().current_scene.get_node("Game Manager")
		if gm:
			gm.add_key()
		Global.key_collected.emit()
		animation_player.play("key pickup")

func _on_zone_1_body_entered(body: Node2D) -> void:
	#print("zone 1 entered by: ", body.name)
	if body.is_in_group("Player") and not zone1_triggered:
		zone1_triggered = true
		Global.key_zone_1.emit()

func _on_zone_2_body_entered(body: Node2D) -> void:
	#print("zone 2 entered by: ", body.name)
	if body.is_in_group("Player") and not zone2_triggered:
		zone2_triggered = true
		Global.key_zone_2.emit()

func _on_zone_3_body_entered(body: Node2D) -> void:
	#print("zone 3 entered by: ", body.name)
	if body.is_in_group("Player") and not zone3_triggered:
		zone3_triggered = true
		Global.key_zone_3.emit()

func _on_zone_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not zone4_triggered:
		zone4_triggered = true
		Global.key_zone_1.emit()
