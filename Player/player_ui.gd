extends Control
class_name PlayerUI

@onready var player_gameplay_info: Label = $PlayerGameplayInfo
@onready var timer: Timer = $Timer
@onready var walker: WalkerModel = $"../WalkerFixedPoint/Walker"
@onready var top_text: MarginContainer = $TopText
@onready var top_lable: Label = $TopText/GrabWalkerUI/TopLable
@onready var state_machine: StateMachine = $"../StateMachine"

var tween : Tween


func _ready() -> void:
	player_gameplay_info.text = ""


func _process(delta: float) -> void:
	process_top_text(delta)


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


func process_top_text(delta) -> void:
	if state_machine.state is Walker:
		top_text.hide()
		return
	
	for body in walker.walker_grab_area.get_overlapping_bodies():
		if body is Player:
			display_top_text("R - Grab Walker")
			return
	top_text.hide()


func display_top_text(text : String) -> void:
	top_text.show()
	top_lable.text = text
