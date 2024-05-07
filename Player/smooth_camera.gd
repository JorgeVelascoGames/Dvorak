extends Camera3D
class_name WorldCamera

@export_group("Camera smooth")
@export var speed := 60.0
@export var pivot :Node3D

@export_group("Camera shake")
@export var random_strenght: float = 0.7
@export var shake_fade : float = 1.5

@onready var aim_shake_timer = $AimShakeTimer

var random_offset: Vector3
var _delta: float
var shake_strenght: float = 0.0
var rng = RandomNumberGenerator.new()
const shake_frecuency := 0.2
var shaking: bool = true


func _ready():
	aim_shake_timer.wait_time = shake_frecuency


func _process(delta):
	if Input.is_action_just_pressed("test"):
		shake_camera()
	
	if shaking:
		_shaking_camera()


func _physics_process(delta):
	_delta = delta
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
	h_offset = random_offset.x
	v_offset = random_offset.y


func _shaking_camera() -> void:
	shake_strenght = random_strenght

	h_offset = lerpf(h_offset, random_offset.x, shake_fade * _delta)
	v_offset = lerpf(v_offset, random_offset.y, shake_fade * _delta)


func _calculate_random_offset() -> void:
	random_offset = Vector3(rng.randf_range(
		-shake_strenght, shake_strenght), 
		rng.randf_range(-shake_strenght, shake_strenght), 
		0
		)


func _on_aim_shake_timer_timeout():
	var diff_float : float = randf_range(0.8, 1.5)
	shake_strenght = random_strenght * diff_float
	_calculate_random_offset()
