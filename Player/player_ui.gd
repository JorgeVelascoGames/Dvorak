extends Control
class_name PlayerUI

@onready var player_gameplay_info: Label = $PlayerGameplayInfo
@onready var timer: Timer = $Timer
var tween : Tween

func _ready() -> void:
	player_gameplay_info.text = ""


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
