extends Node

signal new_threshold_reached(threshold : DANGER_THRESHOLD)

@export var first_warning_cd : float
@export var second_warning_cd : float
@export var third_warning_cd : float

@export var first_warning_threshold : int
@export var second_warning_threshold : int
@export var third_warning_threshold : int

@export var first_warning_messages : Array[String] = []
@export var second_warning_messages : Array[String] = []
@export var third_warning_messages : Array[String] = []

@onready var first_warning_timer: Timer = $FirstWarningTimer
@onready var second_warning_timer: Timer = $SecondWarningTimer
@onready var third_warning_timer: Timer = $ThirdWarningTimer
@onready var balance: Balance = $".."
@onready var player_ui: PlayerUI = get_tree().get_first_node_in_group("player_ui") as PlayerUI
@onready var player_audio : PlayerAudioManager = get_tree().get_first_node_in_group("player_audio") as PlayerAudioManager

enum DANGER_THRESHOLD {none, first, second, third}
var danger_state : DANGER_THRESHOLD = DANGER_THRESHOLD.first

#aviso de que el equilibrio ha bajado a menos de 15%

func show_first_warning() -> void:
	if first_warning_timer.time_left > 0:
		return
	
	player_ui.display_gameplay_text(first_warning_messages.pick_random(), 3, true)
	first_warning_timer.start(first_warning_cd)
	player_ui.balance_overlay_animation_player.play("balance")
	player_audio.play_balance_clue()

func show_second_warning() -> void:
	if second_warning_timer.time_left > 0:
		return
	
	player_ui.display_gameplay_text(second_warning_messages.pick_random(), 3, true)
	second_warning_timer.start(second_warning_cd)
	player_ui.balance_overlay_animation_player.play("balance")
	player_audio.play_balance_clue(.8)


func show_third_warning() -> void:
	if third_warning_timer.time_left > 0:
		return
	
	player_ui.display_gameplay_text(third_warning_messages.pick_random(), 3, true)
	third_warning_timer.start(third_warning_cd)
	player_ui.balance_overlay_animation_player.play("balance")
	player_audio.play_balance_clue(.6)


func _balance_added() -> void:
	if not $"../PillBonusTimer".is_stopped():
		return
	if $"../../../StateMachine".state.name == "Walker":
		return
	var percentage = balance.get_percentage()
	if percentage < first_warning_threshold and danger_state != 0:
		change_threshold(0)
		return
	if percentage < second_warning_threshold and percentage > first_warning_threshold and danger_state != 1:
		change_threshold(1)
		show_first_warning()
		return
	if percentage < third_warning_threshold and percentage > second_warning_threshold and danger_state != 2:
		change_threshold(2)
		show_second_warning()
		return
	if  percentage > third_warning_threshold and danger_state != 3:
		change_threshold(3)
		show_third_warning()


func change_threshold(threshold : DANGER_THRESHOLD) -> void:
	if danger_state == threshold:
		return
	danger_state = threshold
	new_threshold_reached.emit(danger_state)


func _on_check_balance_state_timeout() -> void:
	_balance_added()
