extends Node3D
class_name PassBook

@export var time_to_show_text := 3.0

#Components
@onready var cool_down = $Timers/CoolDown #How much time needs the book to be interactable again after the text has fade out

var switch_number : int
var switch_correct_state : bool
var text : String


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
	
	text = final_text.format([switch_order, switch_state])
	print(text)


func _on_interactable_on_long_interact() -> void:
	if cool_down.time_left > 0:
		return
	
	var player_ui = get_tree().get_first_node_in_group("player_ui") as PlayerUI
	
	player_ui.display_gameplay_text(text, time_to_show_text)
