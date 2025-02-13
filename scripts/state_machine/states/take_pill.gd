extends PlayerState
class_name TakePill

@export var min_keys_to_press := 12
@export var max_keys_to_press := 33

@onready var balanced_ui: BalanceUI = $"../../PlayerUI/BalancedUI"
@onready var inventory: Inventory = $"../../Components/Inventory"
@onready var player_ui: PlayerUI = $"../../PlayerUI"
@onready var balance: Balance = $"../../Components/Balance"
@onready var camera_pivot: Node3D = $"../../CameraPivot"
@onready var animated_gun: Node3D = $"../../AnimatedObjects/PillsModel"
@onready var animation_tree: PlayerAnimationController = $"../../AnimationTree"
@onready var gun_initial_position := animated_gun.position

var necessary_keys_to_press : int
var right_key_selection : String
var left_key_selection : String
enum KeyboardSide {top, right}
var current_side : KeyboardSide = KeyboardSide.right
var right_side_keys = ["right_key_1", "right_key_2", "right_key_q", "right_key_e", "right_key_z", "right_key_x", "right_key_c", "right_key_3"]
var left_side_keys = ["left_key_0", "left_key_9", "left_key_o", "left_key_i", "left_key_l", "left_key_k", "left_key_m"]#left and right were confused due to severe lack of sleep
var correct_key_pressed : int = 0
var tween : Tween


func enter(_msg : ={}) -> void:
	player.player_audio_manager.opening_pills()
	randomize()
	necessary_keys_to_press = randi_range(min_keys_to_press, max_keys_to_press)
	player.velocity = Vector3.ZERO
	left_key_selection = left_side_keys.pick_random()
	right_key_selection = right_side_keys.pick_random()
	balanced_ui.display_keys(left_key_selection, right_key_selection)
	
	animated_gun.show()
	animated_gun.position = Vector3(.3, 0.0, .2)
	tween = get_tree().create_tween()
	tween.set_parallel()
	var target_rotation = Vector3(-60, 0, 0) * deg_to_rad(1)
	tween.tween_property(animated_gun, "position", gun_initial_position, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(camera_pivot, "rotation", target_rotation, 0.45)
	animation_tree["parameters/pills_trigger/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE


func update(_delta):
	if Input.is_action_just_released("take_pills"):
		cancel_and_finish()


func input(event):
	if current_side == KeyboardSide.right:
		if event.is_action_pressed(right_key_selection):
			current_side = KeyboardSide.top
			_correct_key()
	if current_side == KeyboardSide.top:
		if event.is_action_pressed(left_key_selection):
			current_side = KeyboardSide.right
			_correct_key()


func _correct_key() -> void:
	correct_key_pressed += 1
	if correct_key_pressed >= necessary_keys_to_press:
		finish_state()


func finish_state() -> void:
	player.player_audio_manager.cancel_item_sound()
	if inventory.use_pills():
		$"../../Components/Balance".take_pill()
		player.player_health.heal_up()
		player_ui.display_gameplay_text("You took a pill", 3)
		player.player_audio_manager.swallow_pills()
	else:
		player_ui.display_gameplay_text("You don't have any more pills left...", 3)
		player.player_audio_manager.no_pills()
	state_machine.transition_to("Idle", {})


func cancel_and_finish() -> void:
	state_machine.transition_to("Idle", {})
	player.player_audio_manager.cancel_item_sound()


func exit() -> void:
	correct_key_pressed = 0
	animation_tree["parameters/pills_trigger/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	balanced_ui.h_box_container.hide()
	animated_gun.hide()
