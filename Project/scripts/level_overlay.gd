extends Control

signal continued

@export var title_text: String = ""
@export var body_text: String = ""

var _can_continue := false

@onready var title_label: Label = $Box/Margin/VBoxContainer/Title
@onready var body_label: RichTextLabel = $Box/Margin/VBoxContainer/Body
@onready var hint_label: Label = $Box/Margin/VBoxContainer/Hint

func _ready() -> void:
	title_label.text = title_text
	body_label.text = body_text
	hint_label.visible = true
	_can_continue = true

	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if not _can_continue:
		return

	if event.is_action_pressed("ui_accept") or event.is_action_pressed("jump"):
		_can_continue = false
		get_tree().paused = false
		emit_signal("continued")
		queue_free()
