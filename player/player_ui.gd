extends Control
class_name PlayerUI

signal update_constant_hints
signal update_interaction_hints

@onready var player_gameplay_info: Label = $PlayerGameplayInfo
@onready var timer: Timer = $Timer
@onready var walker: WalkerModel = $"../WalkerFixedPoint/Walker"
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var const_text: MarginContainer = $"ControlHints/Const-Text"
@onready var i_text: MarginContainer = $"ControlHints/I-Text"
@onready var const_lable: Label = $"ControlHints/Const-Text/GrabWalkerUI/ConstLable"
@onready var interaction_lable: Label = $"ControlHints/I-Text/GrabWalkerUI/InteractionLable"
@onready var player_game_menu: Control = $PlayerGameMenu
@onready var player_vhs_effect: VHSEffect = $PlayerVHSEffect
@onready var balance_overlay: TextureRect = $BalanceOverlay
@onready var balance_overlay_animation_player: AnimationPlayer = $BalanceOverlay/BalanceOverlayAnimationPlayer
@onready var danger_overlay: TextureRect = $DangerOverlay
@onready var player_health: PlayerHealth = $"../Components/PlayerHealth"
@onready var damaged_overlay: TextureRect = $DamagedOverlay
@onready var dying_overlay: TextureRect = $DyingOverlay

const SCREEN_OVERLAY_BALANCE_01 = preload("uid://cngiemxinj0jx")

var tween : Tween
var r_hint_priority := 0
var constant_hints_to_display : Array[Hint] = []
var interact_hints_to_display : Array[Hint] = []
var dying_overlay_screens : Array[CompressedTexture2D] = [
	preload("uid://bm0w456skdflw"),
	preload("uid://2p6oygmy1yto"),
	preload("uid://dcu5m0bd1f3lg")
]
var danger_overlay_screens : Array[CompressedTexture2D] = [
	preload("uid://cybbasys4aa0v"),
	preload("uid://ghviyvynlgu2"),
	preload("uid://coammvgktdxvh")
]


func _ready() -> void:
	update_constant_hints.connect(write_constant_hints)
	update_interaction_hints.connect(write_interaction_hints)
	player_gameplay_info.text = ""
	const_text.hide()
	i_text.hide()


func display_gameplay_text(text : String, time : float, low_priority_text  := false, clean_text := false) -> void:
	if low_priority_text and player_gameplay_info.text != "":
		return
	if !timer.is_stopped():
		timer.stop()
	if tween != null and tween.is_running():
		tween.kill #In case multiple messages come at the same time
	
	if clean_text:
		player_gameplay_info.text = ""
	
	player_gameplay_info.modulate.a = 1
	player_gameplay_info.text += "\n" + text
	timer.start(time)
	await timer.timeout
	tween = get_tree().create_tween()
	tween.tween_property(player_gameplay_info, "modulate:a", 0.0, 2.0)
	await tween.finished
	tween = null
	player_gameplay_info.text = ""


func add_interaction_hint(hint : Hint) -> void:
	if interact_hints_to_display.has(hint):
		return
	interact_hints_to_display.append(hint)
	update_interaction_hints.emit()


func hide_interaction_hint(hint : Hint) -> void:
	if interact_hints_to_display.has(hint):
		interact_hints_to_display.erase(hint)
		update_interaction_hints.emit()


func add_constant_hint(hint : Hint) -> void:
	if constant_hints_to_display.has(hint):
		return
	constant_hints_to_display.append(hint)
	update_constant_hints.emit()


func hide_constant_hint(hint : Hint) -> void:
	if constant_hints_to_display.has(hint):
		constant_hints_to_display.erase(hint)
		update_constant_hints.emit()


func write_constant_hints() -> void:
	if constant_hints_to_display.is_empty():
		const_lable.text = ""
		const_text.hide()
		return
	
	var selected_hint : Hint = constant_hints_to_display[0]
	
	for hint in constant_hints_to_display:
		if hint.priority > selected_hint.priority:
			selected_hint = hint
	
	const_text.show()
	const_lable.text = selected_hint.hint


func write_interaction_hints() -> void:
	if interact_hints_to_display.is_empty():
		interaction_lable.text = ""
		i_text.hide()
		return
	
	var selected_hint : Hint = interact_hints_to_display[0]
	
	for hint in interact_hints_to_display:
		if hint.priority > selected_hint.priority:
			selected_hint = hint
	
	i_text.show()
	interaction_lable.text = selected_hint.hint


func _on_player_health_new_heal_state(HEAL_STATE: PlayerHealth.HEALTH_STATE) -> void:
	match HEAL_STATE:
		PlayerHealth.HEALTH_STATE.healthy:
			damaged_overlay.hide()
			dying_overlay.hide()
			player_vhs_effect.close_vhs_effect(3)
		PlayerHealth.HEALTH_STATE.injure:
			damaged_overlay.show()
			dying_overlay.hide()
			player_vhs_effect.show()
			player_vhs_effect.shader_mat.set_shader_parameter("tape_crease_smear", 0.3)
			player_vhs_effect.shader_mat.set_shader_parameter("crease_noise", 0.3)
		PlayerHealth.HEALTH_STATE.dying:
			dying_overlay.texture = dying_overlay_screens.pick_random()
			damaged_overlay.show()
			dying_overlay.show()
			player_vhs_effect.shader_mat.set_shader_parameter("tape_crease_smear", 2.0)
			player_vhs_effect.shader_mat.set_shader_parameter("crease_noise", 2.0)
			player_vhs_effect.tween_crease_noise(0.3, player_health.time_to_recover_from_dying)
			player_vhs_effect.tween_tape_crease_smear(0.3, player_health.time_to_recover_from_dying)
