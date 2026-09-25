extends Node2D

@export var transition_scene_path: String = "res://scenes/LevelTransition.tscn"
@export var next_level_path: String = "res://scenes/level2.tscn"
@export var level_title: String = ""
@export var narrative_text: String = ""

@onready var sprite = $StatueSprite

var changing := false
var time := 0.0


func _process(delta):
	time += delta
	
	# subtle pulse
	var scale_offset = sin(time * 3.0) * 0.01
	sprite.scale = Vector2(1, 1) + Vector2(scale_offset, scale_offset)
	
	# subtle glow
	var glow = 0.08 * sin(time * 2.5)
	sprite.modulate = Color(1.0 + glow, 1.0 + glow, 1.0 + glow, 1.0)


func _on_trigger_area_body_entered(body: Node) -> void:
	if changing:
		return
	if body.is_in_group("Player"):
		changing = true
		call_deferred("_go_next_level")


func _go_next_level() -> void:
	# determine next level automatically
	var current_scene = get_tree().current_scene.scene_file_path

	if current_scene == "res://scenes/level1.tscn":
		next_level_path = "res://scenes/level2.tscn"
	elif current_scene == "res://scenes/level2.tscn":
		next_level_path = "res://scenes/level3.tscn"
	elif current_scene == "res://scenes/level3.tscn":
		next_level_path = "res://scenes/game_finished.tscn"  

	# fade out
	var fade = ColorRect.new()
	fade.color = Color(0, 0, 0, 0)
	fade.set_anchors_preset(Control.PRESET_FULL_RECT)
	get_tree().current_scene.add_child(fade)

	var tween = create_tween()
	tween.tween_property(fade, "color:a", 1.0, 0.7)

	await get_tree().create_timer(0.15).timeout

	# instantiate transition scene and pass data
	var scene = load(transition_scene_path).instantiate()

	scene.next_level_path = next_level_path
	scene.level_title = level_title
	scene.narrative_text = narrative_text

	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
