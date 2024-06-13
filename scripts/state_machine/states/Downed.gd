extends PlayerState
class_name Downed

@export var necessary_keys_to_press : int 

var left_key_selection : String
var right_key_selection : String
enum KeyboardSide {left, right}
var current_side : KeyboardSide = KeyboardSide.right
var top_side_keys = ["top_key_4", "top_key_5", "top_key_6", "top_key_7", "top_key_t","top_key_y"]
var bot_side_keys = ["bot_key_v", "bot_key_b", "bot_key_f", "bot_key_g",  "bot_key_h"]
var correct_key_pressed : int = 0

@onready var placeholder_l_able = $BalancedUI/PlaceholderLAble


func enter(_msg : ={}) -> void:
	player.velocity = Vector3.ZERO
	left_key_selection = top_side_keys.pick_random()
	right_key_selection = bot_side_keys.pick_random()
	placeholder_l_able.show()
	placeholder_l_able.text = left_key_selection + " + " + right_key_selection


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
	correct_key_pressed += 1
	if correct_key_pressed >= necessary_keys_to_press:
		state_machine.transition_to("Idle", {})


func exit() -> void:
	correct_key_pressed = 0
	placeholder_l_able.hide()
