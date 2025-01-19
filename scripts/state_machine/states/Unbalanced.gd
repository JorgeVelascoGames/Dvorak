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
var finished_state := false

@onready var original_margin_of_error : float = margin_of_error
@onready var timer = $Timer
@onready var error_timer = $ErrorTimer
@onready var animation_player = $"../../AnimationPlayer"
@onready var camera_pivot = $"../../CameraPivot"
@onready var camera_pivot_pos_y : float = camera_pivot.position.y
@onready var animation_tree = $"../../AnimationTree"
@onready var balanced_ui: BalanceUI = $"../../PlayerUI/BalancedUI"


func enter(_msg : ={}) -> void:
	if player.flashlight.visible:
		player.flashlight.hide()
		player.flashlight.flashlight_battery.paused = true
	finished_state = false
	player.velocity = Vector3.ZERO
	left_key_selection = left_side_keys.pick_random()
	right_key_selection = right_side_keys.pick_random()
	balanced_ui.display_keys(left_key_selection, right_key_selection)
	timer.start(time_to_keep_balance)
	error_timer.start(margin_of_error)
	#animation_player.play("unbalanced")
	blend_animations()


func update(_delta):
	pass


func physics_update(_delta: float) -> void:
	pass


func input(event):
	if finished_state:
		return
	
	if current_side == KeyboardSide.right:
		if event.is_action_pressed(right_key_selection):
			current_side = KeyboardSide.left
			_correct_key()
	if current_side == KeyboardSide.left:
		if event.is_action_pressed(left_key_selection):
			current_side = KeyboardSide.right
			_correct_key()


func blend_animations() -> void:
	animation_tree["parameters/floor_blend/blend_amount"] = 0.0
	var tween = create_tween()
	tween.tween_method(blend_unbalanced, 0.0, 1.0, 2.0)


func blend_unbalanced(amount : float) -> void:
	animation_tree["parameters/unbalanced_blend/blend_amount"] = amount


func blend_to_fix_pivot(amount : float) -> void:
		animation_tree["parameters/fix_pivot_movement/blend_amount"] = amount


func _correct_key() -> void:
	#print("correct key landed")
	error_timer.start(margin_of_error)
	correct_key_pressed += 1
	if correct_key_pressed >= necessary_keys_to_press:
		margin_of_error -= difficulty_increase
		if margin_of_error < 0:
			margin_of_error = 0.2
		finish_state("Idle")


func finish_state(state : String) -> void:
	finished_state = true
	timer.stop()
	error_timer.stop()
	correct_key_pressed = 0
	balanced_ui.h_box_container.hide()
	
	var tween
	
	if state == "Idle":
		tween = create_tween().set_parallel(true)
		tween.tween_method(blend_unbalanced, animation_tree["parameters/unbalanced_blend/blend_amount"], 0.0, 0.6)
		#tween.tween_property(camera_pivot, "position", Vector3(0, camera_pivot_pos_y, 0), 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.tween_method(blend_to_fix_pivot, 0.0, 1.0, 1.3)
		tween.tween_property(camera_pivot, "rotation", Vector3(camera_pivot.rotation.x, 0, 0), 1.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		await tween.finished
	else:
		tween = create_tween()
		tween.tween_method(blend_unbalanced, animation_tree["parameters/unbalanced_blend/blend_amount"], 0.0, 1.0) #So it blends with the tween transition on floor animation inside of Downed state
	
	state_machine.transition_to(state, {})


func exit() -> void:
	pass


func _on_timer_timeout():
	margin_of_error = original_margin_of_error
	finish_state("Downed")


func _on_error_timer_timeout():
	margin_of_error = original_margin_of_error
	finish_state("Downed")
