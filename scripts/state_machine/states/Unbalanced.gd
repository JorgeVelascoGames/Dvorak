extends PlayerState
class_name Unbalanced

var left_key_selection : String
var right_key_selection : String
enum KeyboardSide {left, right}
var current_side : KeyboardSide = KeyboardSide.right
var left_side_keys = ["left_key_0", "left_key_9", "left_key_p", "left_key_o", "left_key_i", "left_key_l", "left_key_k", "left_key_m"]
var right_side_keys = ["right_key_1", "right_key_2", "right_key_q", "right_key_e", "right_key_z", "right_key_x", "right_key_c", "right_key_3"]


func enter(_msg : ={}) -> void:
	left_key_selection = left_side_keys.pick_random()
	right_key_selection = right_side_keys.pick_random()
	#TODO
	#DISPLAY UI


func update(delta):
	pass


func physics_update(delta: float) -> void:
	pass


func input(event):
	if current_side == KeyboardSide.right:
		if event.is_action_pressed(right_key_selection):
			pass
	if current_side == KeyboardSide.left:
		pass
