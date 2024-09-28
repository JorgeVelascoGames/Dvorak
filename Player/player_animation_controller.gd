extends AnimationTree
class_name PlayerAnimationController

@export_range(0.0, 1.0) var low_threshold := 0.4
@export_range(0.0, 1.0) var mid_threshold := 0.7
@export_range(0.0, 1.0) var high_threshold := 1.0
@export_range(0.0, 1.0) var low_easing_ratio := 0.3
@export_range(0.0, 1.0) var mid_easing_ratio := 0.2
@export_range(0.0, 1.0) var high_easing_ratio := 0.1

@onready var balance: Balance = $"../Components/Balance"

var ratio := 0.4
var anim_value : float

func _process(delta: float) -> void:
	losing_balance(delta)


func losing_balance(delta : float) -> void:
	var value := 0.0
	if owner.state_machine.state is Walk or owner.state_machine.state is PlayerIdle:
		value = (balance.get_percentage() / 100)
	
	if value < low_threshold:
		ratio = low_easing_ratio
	elif value < mid_threshold:
		ratio = mid_easing_ratio
	elif value < high_threshold:
		ratio = high_easing_ratio
	
	value -= ratio
	value = clampf(value, 0, 1)
	anim_value = lerpf(anim_value, value, delta)
	
	self["parameters/losing_balance/blend_amount"] = anim_value
