extends Control
class_name PlayerUI

@onready var player_gameplay_info: Label = $PlayerGameplayInfo
@onready var timer: Timer = $Timer
@onready var walker: WalkerModel = $"../WalkerFixedPoint/Walker"
@onready var top_lable: Label = $TopText/GrabWalkerUI/TopLable
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var r_text: MarginContainer = $"ControlHints/R-Text"
@onready var i_text: MarginContainer = $"ControlHints/I-Text"

var tween : Tween
var r_hint_priority := 0


func _ready() -> void:
	player_gameplay_info.text = ""
	r_text.hide()
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

##Call this method on process with a priority higher than 0
func show_interaction_hint(hint : String) -> void:
	i_text.show()
	$"ControlHints/I-Text/GrabWalkerUI/TopLable".text = hint


func hide_interaction_hint() -> void:
	i_text.hide()
	$"ControlHints/I-Text/GrabWalkerUI/TopLable".text = ""

##Call this method on process with a priority higher than 0
func show_constant_hint(hint : String, priority := 0) -> void:
	if r_hint_priority > priority:
		return
	r_hint_priority = priority
	r_text.show()
	$"ControlHints/R-Text/GrabWalkerUI/TopLable".text = hint


func hide_constant_hint() -> void:
	r_hint_priority = 0
	r_text.hide()
	$"ControlHints/R-Text/GrabWalkerUI/TopLable".text = ""
