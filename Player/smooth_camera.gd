extends Camera3D
class_name WorldCamera

@export_group("Camera smooth")
@export var speed := 60.0
@export var pivot :Node3D

@onready var aim_shake_timer = $AimShakeTimer
@onready var offset_calculation_timer = $OffsetCalculationTimer

var random_offset: Vector3
var shake_strenght: float = 0.0
var rng = RandomNumberGenerator.new()
var shaking: bool = false
const random_strenght: = 0.3
const shake_fade : = 0.5
const shake_frecuency := 0.3


func _ready():
	aim_shake_timer.wait_time = shake_frecuency
	aim_shake_timer.wait_time = rng.randf_range(5.0, 8.0)


func _process(delta):
	if Input.is_action_just_pressed("test"):
		shake_camera()
	
	if shaking:
		_shaking_camera(delta)
	else:
		reset_offset(delta)


func _physics_process(delta):
	_smooth_camera(delta)


func _smooth_camera(delta) -> void:
	var weight :float = clamp(delta * speed, 0.0, 0.5) 
	
	global_transform = global_transform.interpolate_with(
		get_parent().global_transform, weight
	)
	global_position = get_parent().global_position


func shake_camera() -> void:
	shake_strenght = random_strenght * 1.4
	_calculate_random_offset()
	#tween
	h_offset = random_offset.x
	v_offset = random_offset.y


func _shaking_camera(delta: float) -> void:
	shake_strenght = random_strenght

	h_offset = lerpf(h_offset, random_offset.x, shake_fade * delta)
	v_offset = lerpf(v_offset, random_offset.y, shake_fade * delta)


func _calculate_random_offset() -> void:
	random_offset = Vector3(rng.randf_range(
		-shake_strenght, shake_strenght), 
		rng.randf_range(-shake_strenght, shake_strenght), 
		0
		)


func reset_offset(delta) -> void:
	h_offset = lerpf(h_offset, 0, shake_fade * delta)
	v_offset = lerpf(v_offset, 0, shake_fade * delta)


func _on_aim_shake_timer_timeout():
	if not shaking:
		return
	
	aim_shake_timer.wait_time = rng.randf_range(5.0, 8.0)
	shake_camera()


func _on_offset_calculation_timer_timeout():
	var diff_float : float = randf_range(0.8, 1.5)
	shake_strenght = random_strenght * diff_float
	_calculate_random_offset()
