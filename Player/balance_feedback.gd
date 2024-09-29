extends Node

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

var first_threshold_passed := false
var second_threshold_passed := false
var third_threshold_passed := false

#aviso de que el equilibrio ha bajado a menos de 15%

func show_first_warning() -> void:
	if first_warning_timer.time_left > 0:
		return
	
	player_ui.display_gameplay_text(first_warning_messages.pick_random(), 3)
	first_warning_timer.start(first_warning_cd)


func show_second_warning() -> void:
	if second_warning_timer.time_left > 0:
		return
	
	player_ui.display_gameplay_text(second_warning_messages.pick_random(), 3)
	second_warning_timer.start(second_warning_cd)


func show_third_warning() -> void:
	if third_warning_timer.time_left > 0:
		return
	
	player_ui.display_gameplay_text(third_warning_messages.pick_random(), 3)
	third_warning_timer.start(third_warning_cd)


func _on_balance_balance_added(amount: int) -> void:
	if balance.get_percentage() > first_warning_threshold and first_threshold_passed == false:
		show_first_warning()
		first_threshold_passed = true
	if balance.get_percentage() > second_warning_threshold and second_threshold_passed == false:
		show_second_warning()
		second_threshold_passed = true
	if balance.get_percentage() > third_warning_threshold and third_threshold_passed == false:
		show_third_warning()
		third_threshold_passed = true
		
	if balance.get_percentage() < first_warning_threshold:
		first_threshold_passed = false
	if balance.get_percentage() < second_warning_threshold:
		second_threshold_passed = false
	if balance.get_percentage() < third_warning_threshold:
		third_threshold_passed = false
