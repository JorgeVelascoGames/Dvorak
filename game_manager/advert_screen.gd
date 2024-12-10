extends Control

@onready var timer: Timer = $Timer
var ready_to_continue := false
@onready var label: Label = $MarginContainer/Label


func _ready() -> void:
	label.hide()
	timer.start(1.2)
	await timer.timeout
	ready_to_continue = true
	var tween = get_tree().create_tween()
	label.modulate.a = 0.0
	label.show()
	tween.tween_property(label, "modulate:a", 1.0, 1.0)


func _input(event: InputEvent) -> void:
	if not ready_to_continue:
		return
	
	if event.is_pressed() and (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton):
		AppManager.game_manager.next_app_state()
