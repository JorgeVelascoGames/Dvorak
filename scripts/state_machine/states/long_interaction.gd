extends PlayerState
class_name PlayerLongInteraction

@export var necessary_keys_to_press_min := 15
@export var necessary_keys_to_press_max := 25

@onready var balance = $"../../Components/Balance"
@onready var placeholder_l_able: Label = $PlayerUI/BalancedUI/PlaceholderLAble


#Private variables
var interactable : Interactable

var necessary_keys_to_press : int
var right_key_selection : String
var top_key_selection : String
enum KeyboardSide {top, right}
var current_side : KeyboardSide = KeyboardSide.right
var right_side_keys = ["right_key_1", "right_key_2", "right_key_q", "right_key_e", "right_key_z", "right_key_x", "right_key_c", "right_key_3"]
var top_side_keys = ["top_key_4", "top_key_5", "top_key_6", "top_key_7", "top_key_t","top_key_y"]
var correct_key_pressed : int = 0


func enter(_msg : ={}) -> void:
	interactable = _msg["object"]
	necessary_keys_to_press = randi_range(necessary_keys_to_press_min, necessary_keys_to_press_max)
	player.velocity = Vector3.ZERO
	top_key_selection = top_side_keys.pick_random()
	right_key_selection = right_side_keys.pick_random()
	placeholder_l_able.show()
	placeholder_l_able.text = top_key_selection + " + " + right_key_selection


func update(_delta):
	if Input.is_action_just_released("interact"):
		state_machine.transition_to("Idle", {})


func input(event):
	if current_side == KeyboardSide.right:
		if event.is_action_pressed(right_key_selection):
			current_side = KeyboardSide.top
			_correct_key()
	if current_side == KeyboardSide.top:
		if event.is_action_pressed(top_key_selection):
			current_side = KeyboardSide.right
			_correct_key()


func physics_update(delta: float) -> void:
	pass


func _correct_key() -> void:
	correct_key_pressed += 1
	if correct_key_pressed >= necessary_keys_to_press:
		finish_state()


func finish_state() -> void:
	interactable
	correct_key_pressed = 0
	placeholder_l_able.hide()
	
	state_machine.transition_to("Idle", {})


func exit() -> void:
	pass
