extends AnimationTree
class_name PlayerAnimationController

@export_range(0.0, 1.0) var low_threshold := 0.35
@export_range(0.0, 1.0) var mid_threshold := 0.55
@export_range(0.0, 1.0) var high_threshold := 0.85
@export_range(0.0, 1.0) var low_easing_ratio := 0.3
@export_range(0.0, 1.0) var mid_easing_ratio := 0.2
@export_range(0.0, 1.0) var high_easing_ratio := 0.1

@onready var balance: Balance = $"../Components/Balance"
@onready var state_machine: StateMachine = $"../StateMachine"

var ratio := 0.4
var anim_value : float

func _process(delta: float) -> void:
	losing_balance(delta)


func losing_balance(delta : float) -> void:
	if owner.state_machine.state is PrepareGun:
		self["parameters/losing_balance/blend_amount"] = 0.0
		return
	
	var value := 0.0
	if owner.state_machine.state is Walk or owner.state_machine.state is PlayerIdle:
		value = (balance.get_percentage() / 100)
	
	if value < low_threshold:
		ratio = low_easing_ratio
	elif value < mid_threshold:
		ratio = mid_easing_ratio
	elif value < high_threshold:
		ratio = high_easing_ratio
	else:
		ratio = 0.0
	
	value -= ratio
	value = clampf(value, 0, 1)
	anim_value = lerpf(anim_value, value, delta)
	
	self["parameters/losing_balance/blend_amount"] = anim_value


func _on_state_machine_transitioned(state_name: Variant) -> void:
	var tween : Tween
	var state_names : String = "WalkIdlePrepareGunWalker" as String #The states in which the animation needs no movement
	if state_names.contains(state_name):
		if not state_names.contains(state_machine.last_state):
			if tween:
				tween.kill()
			tween = create_tween()
			tween.tween_method(blend_to_fix_pivot, 0.0, 1.0, 1.7)
	else:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_method(blend_to_fix_pivot, 1.0, 0.0, 1.7)


func blend_to_fix_pivot(amount : float) -> void:
		self["parameters/fix_pivot_movement/blend_amount"] = amount
