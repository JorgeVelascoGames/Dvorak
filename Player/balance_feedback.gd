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
@onready var player_ui: PlayerUI = $PlayerUI

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
	player_ui.display_gameplay_text(third_warning_messages.pick_random(), 3)


func _on_balance_balance_added(amount: int) -> void:
	if balance.get_percentage() > first_warning_threshold:
		show_first_warning()
	if balance.get_percentage() > second_warning_threshold:
		show_second_warning()
	if balance.get_percentage() > third_warning_threshold:
		show_third_warning()
