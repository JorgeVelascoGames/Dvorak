extends Node3D
class_name PassBook

var switch_number : int
var switch_correct_state : bool

#Components
@onready var text = $Control/CenterContainer/Text
@onready var canvas_modulate = $Control/CanvasModulate
@onready var show_text_timer = $Timers/ShowTextTimer
@onready var fade_out_text_timer = $Timers/FadeOutTextTimer
@onready var cool_down = $Timers/CoolDown #How much time needs the book to be interactable again after the text has fade out


func _process(_delta):
	if fade_out_text_timer.time_left > 0:
		canvas_modulate.color.a = fade_out_text_timer.time_left / fade_out_text_timer.wait_time


func set_up_book(state: bool, number : int) -> void:
	switch_number = number
	switch_correct_state = state
	var final_text = "The {0} switch must be {1}"
	var switch_order : String
	var switch_state : String
	if switch_correct_state:
		switch_state = "active"
	else:
		switch_state = "unactive"
	match number:
		1:
			switch_order = "first"
		2:
			switch_order = "second"
		3:
			switch_order = "third"
		4:
			switch_order = "fourth"
		5:
			switch_order = "fifth"
		6:
			switch_order = "sixth"
		7:
			switch_order = "seventh"
		8:
			switch_order = "eighth"
		9:
			switch_order = "ninth"
		10:
			switch_order = "tenth"
		_:
			switch_order = str(number)
	text.text = final_text.format([switch_order, switch_state])

func _on_interactable_on_interact():
	if cool_down.time_left > 0:
		return
	
	cool_down.start(cool_down.wait_time + show_text_timer.wait_time + fade_out_text_timer.wait_time)
	show_text_timer.start()
	canvas_modulate.color.a = 1
	
	await  show_text_timer.timeout
	
	fade_out_text_timer.start()
