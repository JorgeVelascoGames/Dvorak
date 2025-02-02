extends PlayerState
class_name Downed

@export var necessary_keys_to_press_min := 15
@export var necessary_keys_to_press_max := 25
@export_range(0, 100) var probability_to_lose_items : int

@onready var animation_player = $"../../AnimationPlayer"
@onready var camera_pivot = $"../../CameraPivot"
@onready var camera_pivot_pos_y : float = camera_pivot.position.y
@onready var animation_tree: PlayerAnimationController = $"../../AnimationTree"
@onready var balanced_ui: BalanceUI = $"../../PlayerUI/BalancedUI"

var necessary_keys_to_press : int 
var left_key_selection : String
var right_key_selection : String
enum KeyboardSide {left, right}
var current_side : KeyboardSide = KeyboardSide.right
var top_side_keys = ["top_key_4", "top_key_5", "top_key_6", "top_key_7", "top_key_t","top_key_y"]
var bot_side_keys = ["bot_key_v", "bot_key_b", "bot_key_f", "bot_key_g",  "bot_key_h"]
var correct_key_pressed : int = 0
var difficulty_increase := 5
var max_difficulty_increase_coef := 2.2


func enter(_msg : ={}) -> void:
	necessary_keys_to_press = randi_range(necessary_keys_to_press_min, necessary_keys_to_press_max)
	player.velocity = Vector3.ZERO
	left_key_selection = top_side_keys.pick_random()
	right_key_selection = bot_side_keys.pick_random()
	balanced_ui.display_keys(left_key_selection, right_key_selection)
	#animation_player.play("floor")
	blend_animations()
	
	if randi_range(0, 100) < probability_to_lose_items:
		player.inventory.lose_item_random()

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
	balanced_ui.h_box_container.hide()
	await get_tree().create_timer(0.4).timeout
	#animation_player.stop()
	var tween = create_tween().set_parallel(true)
	tween.tween_method(blend_floor, 1.0, 0.0, 2.8)
	tween.tween_method(blend_to_fix_pivot, 0.0, 1.0, 2.9).set_ease(Tween.EASE_IN_OUT)
	#tween.tween_property(camera_pivot, "position", Vector3(0, player.originCamPos.y, 0), 3.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(camera_pivot, "rotation", Vector3(0, 0, 0), 3.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	
	await tween.finished
	
	state_machine.transition_to("Idle", {})


func blend_to_fix_pivot(amount : float) -> void:
		animation_tree["parameters/fix_pivot_movement/blend_amount"] = amount


func exit() -> void:
	#increase de difficulty for the next time
	necessary_keys_to_press_min += difficulty_increase
	necessary_keys_to_press_max += difficulty_increase
	necessary_keys_to_press_min = clampi(necessary_keys_to_press_min, 1, necessary_keys_to_press_min * max_difficulty_increase_coef)
	necessary_keys_to_press_max = clampi(necessary_keys_to_press_max, 1, necessary_keys_to_press_max * max_difficulty_increase_coef)
	if necessary_keys_to_press_max >= necessary_keys_to_press_max * max_difficulty_increase_coef:
		probability_to_lose_items += probability_to_lose_items * 0.2
		probability_to_lose_items = clampi(probability_to_lose_items, 1, 90)
