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
@onready var animation_player = $"../../AnimationPlayer"
@onready var camera_pivot = $"../../CameraPivot"
@onready var camera_pivot_pos_y : float = camera_pivot.position.y
@onready var animation_tree = $"../../AnimationTree"


func enter(_msg : ={}) -> void:
	player.velocity = Vector3.ZERO
	left_key_selection = top_side_keys.pick_random()
	right_key_selection = bot_side_keys.pick_random()
	placeholder_l_able.show()
	placeholder_l_able.text = left_key_selection + " + " + right_key_selection
	#animation_player.play("floor")
	blend_animations()


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


func blend_animations() -> void:
	var tween = create_tween()
	tween.tween_method(blend_floor, 0.0, 1.0, 1.0)


func blend_floor(amount : float) -> void:
	animation_tree["parameters/floor_blend/blend_amount"] = amount


func _correct_key() -> void:
	correct_key_pressed += 1
	if correct_key_pressed >= necessary_keys_to_press:
		finish_state()


func finish_state() -> void:
	correct_key_pressed = 0
	placeholder_l_able.hide()
	#animation_player.stop()
	
	var tween = create_tween()
	tween.tween_method(blend_floor, 1.0, 0.0, 0.4)
	await tween.finished
	
	tween = create_tween().set_parallel(true)
	tween.tween_property(camera_pivot, "position", Vector3(0, camera_pivot_pos_y, 0), 3.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(camera_pivot, "rotation", Vector3(0, 0, 0), 0.8)
	
	await tween.finished
	
	state_machine.transition_to("Idle", {})


func exit() -> void:
	pass
