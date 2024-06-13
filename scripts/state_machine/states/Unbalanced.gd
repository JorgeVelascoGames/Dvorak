extends PlayerState
class_name Unbalanced

@export var time_to_keep_balance : float
@export var necessary_keys_to_press : int 
@export var margin_of_error : float
@export var difficulty_increase : float

var left_key_selection : String
var right_key_selection : String
enum KeyboardSide {left, right}
var current_side : KeyboardSide = KeyboardSide.right
var left_side_keys = ["left_key_0", "left_key_9", "left_key_p", "left_key_o", "left_key_i", "left_key_l", "left_key_k", "left_key_m"]#left and right were confused due to severe lack of sleep
var right_side_keys = ["right_key_1", "right_key_2", "right_key_q", "right_key_e", "right_key_z", "right_key_x", "right_key_c", "right_key_3"]
var correct_key_pressed : int = 0

@onready var original_margin_of_error : float = margin_of_error
@onready var timer = $Timer
@onready var placeholder_l_able = $BalancedUI/PlaceholderLAble
@onready var error_timer = $ErrorTimer


func enter(_msg : ={}) -> void:
	player.velocity = Vector3.ZERO
	left_key_selection = left_side_keys.pick_random()
	right_key_selection = right_side_keys.pick_random()
	placeholder_l_able.show()
	placeholder_l_able.text = left_key_selection + " + " + right_key_selection
	timer.start(time_to_keep_balance)
	error_timer.start(margin_of_error)


func update(_delta):
	pass


func physics_update(_delta: float) -> void:
	pass


func input(event):
	if current_side == KeyboardSide.right:
		if event.is_action_pressed(right_key_selection):
			current_side = KeyboardSide.left
			_correct_key()
	if current_side == KeyboardSide.left:
		if event.is_action_pressed(left_key_selection):
			current_side = KeyboardSide.right
			_correct_key()


func _correct_key() -> void:
	print("correct key landed")
	error_timer.start(margin_of_error)
	correct_key_pressed += 1
	if correct_key_pressed >= necessary_keys_to_press:
		margin_of_error -= difficulty_increase
		state_machine.transition_to("Idle", {})


func exit() -> void:
	correct_key_pressed = 0
	placeholder_l_able.hide()
	timer.stop()
	error_timer.stop()


func _on_timer_timeout():
	margin_of_error = original_margin_of_error
	state_machine.transition_to("Downed", {})


func _on_error_timer_timeout():
	margin_of_error = original_margin_of_error
	state_machine.transition_to("Downed", {})
