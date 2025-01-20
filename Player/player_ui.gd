extends Control
class_name PlayerUI

signal update_constant_hints
signal update_interaction_hints

@onready var player_gameplay_info: Label = $PlayerGameplayInfo
@onready var timer: Timer = $Timer
@onready var walker: WalkerModel = $"../WalkerFixedPoint/Walker"
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var const_text: MarginContainer = $"ControlHints/Const-Text"
@onready var i_text: MarginContainer = $"ControlHints/I-Text"
@onready var const_lable: Label = $"ControlHints/Const-Text/GrabWalkerUI/ConstLable"
@onready var interaction_lable: Label = $"ControlHints/I-Text/GrabWalkerUI/InteractionLable"
@onready var damaged_overlay: ColorRect = $DamagedOverlay

var tween : Tween
var r_hint_priority := 0
var constant_hints_to_display : Array[Hint] = []
var interact_hints_to_display : Array[Hint] = []


func _ready() -> void:
	update_constant_hints.connect(write_constant_hints)
	update_interaction_hints.connect(write_interaction_hints)
	player_gameplay_info.text = ""
	const_text.hide()
	i_text.hide()


func display_gameplay_text(text : String, time : float) -> void:
	if !timer.is_stopped():
		timer.stop()
	if tween != null and tween.is_running():
		tween.kill #This 2 ifs are in case multiple messages come at the same time
	player_gameplay_info.modulate.a = 1
	player_gameplay_info.text += "\n" + text
	timer.start(time)
	await timer.timeout
	tween = get_tree().create_tween()
	tween.tween_property(player_gameplay_info, "modulate:a", 0.0, 2.0)
	await tween.finished
	player_gameplay_info.text = ""


func add_interaction_hint(hint : Hint) -> void:
	if interact_hints_to_display.has(hint):
		return
	interact_hints_to_display.append(hint)
	update_interaction_hints.emit()


func hide_interaction_hint(hint : Hint) -> void:
	if interact_hints_to_display.has(hint):
		interact_hints_to_display.erase(hint)
		update_interaction_hints.emit()


func add_constant_hint(hint : Hint) -> void:
	if constant_hints_to_display.has(hint):
		return
	constant_hints_to_display.append(hint)
	update_constant_hints.emit()


func hide_constant_hint(hint : Hint) -> void:
	if constant_hints_to_display.has(hint):
		constant_hints_to_display.erase(hint)
		update_constant_hints.emit()


func write_constant_hints() -> void:
	if constant_hints_to_display.is_empty():
		const_lable.text = ""
		const_text.hide()
		return
	
	var selected_hint : Hint = constant_hints_to_display[0]
	
	for hint in constant_hints_to_display:
		if hint.priority > selected_hint.priority:
			selected_hint = hint
	
	const_text.show()
	const_lable.text = selected_hint.hint


func write_interaction_hints() -> void:
	if interact_hints_to_display.is_empty():
		interaction_lable.text = ""
		i_text.hide()
		return
	
	var selected_hint : Hint = interact_hints_to_display[0]
	
	for hint in interact_hints_to_display:
		if hint.priority > selected_hint.priority:
			selected_hint = hint
	
	i_text.show()
	interaction_lable.text = selected_hint.hint
