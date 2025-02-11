extends PlayerState
class_name LoadGun

@export var min_keys_to_press := 12
@export var max_keys_to_press := 33

@onready var inventory: Inventory = $"../../Components/Inventory"
@onready var player_ui: PlayerUI = $"../../PlayerUI"
@onready var balance: Balance = $"../../Components/Balance"
@onready var camera_pivot: Node3D = $"../../CameraPivot"
@onready var ammo_counter: AmmoCounter = $"../../Components/AmmoCounter"
@onready var animated_gun: Node3D = $"../../AnimatedObjects/GunModel"
@onready var gun_initial_position := animated_gun.position
@onready var animation_tree: PlayerAnimationController = $"../../AnimationTree"
@onready var balanced_ui: BalanceUI = $"../../PlayerUI/BalancedUI"

var necessary_keys_to_press : int
var right_key_selection : String
var left_key_selection : String
enum KeyboardSide {left, right}
var current_side : KeyboardSide = KeyboardSide.right
var right_side_keys = ["right_key_1", "right_key_2", "right_key_q", "right_key_e", "right_key_z", "right_key_x", "right_key_c", "right_key_3"]
var left_side_keys = ["left_key_0", "left_key_9", "left_key_p", "left_key_o", "left_key_i", "left_key_k", "left_key_m"]#left and right were confused due to severe lack of sleep
var correct_key_pressed : int = 0
var tween : Tween


func enter(_msg : ={}) -> void:
	necessary_keys_to_press = randi_range(min_keys_to_press, max_keys_to_press)
	player.velocity = Vector3.ZERO
	left_key_selection = left_side_keys.pick_random()
	right_key_selection = right_side_keys.pick_random()
	balanced_ui.display_keys(left_key_selection, right_key_selection)
	player.player_audio_manager.load_gun()
	
	animated_gun.show()
	animated_gun.position = Vector3(.3, 0.0, .2)
	tween = get_tree().create_tween()
	tween.set_parallel()
	var target_rotation = Vector3(-60, 0, 0) * deg_to_rad(1)
	tween.tween_property(animated_gun, "position", gun_initial_position, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(camera_pivot, "rotation", target_rotation, 0.45)
	animation_tree["parameters/load_gun_trigger/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func update(_delta):
	if Input.is_action_just_released("interact"):
		cancel_and_finish()


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
		finish_state()


func finish_state() -> void:
	ammo_counter.reload()
	#TODO sound
	state_machine.transition_to("Idle", {})


func cancel_and_finish() -> void:
	state_machine.transition_to("Idle", {})


func exit() -> void:
	player.player_audio_manager.load_gun()
	animation_tree["parameters/load_gun_trigger/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animated_gun.hide()
	correct_key_pressed = 0
	balanced_ui.h_box_container.hide()
