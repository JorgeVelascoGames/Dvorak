extends Camera3D
class_name WorldCamera

@export_group("Camera smooth")
@export var speed := 60.0
@export var pivot :Node3D

@onready var aim_shake_timer = $AimShakeTimer
@onready var camera_pivot = $".."
@onready var player = $"../.."

var random_offset: Vector3
var shake_strenght: float = 0.0
var rng = RandomNumberGenerator.new()
var shaking: bool = false
const random_strenght: = 0.3
const shake_fade : = 0.3
const shake_frecuency := 0.7


func _ready():
	aim_shake_timer.wait_time = shake_frecuency
	aim_shake_timer.wait_time = rng.randf_range(5.0, 8.0)


func _process(delta):
	#if Input.is_action_just_pressed("test"):
		#weapon_recoil()
	
	if shaking:
		_shaking_camera(delta)
	else:
		reset_offset(delta)


func _physics_process(delta):
	_smooth_camera(delta)


func _smooth_camera(delta) -> void:
	if shaking:
		await get_tree().create_timer(randf_range(0.1,0.5))
	
	var weight :float = clamp(delta * speed, 0.0, 0.5) 
	
	global_transform = global_transform.interpolate_with(
		get_parent().global_transform, weight
	)
	global_position = get_parent().global_position


func _shaking_camera(delta: float) -> void:
	shake_strenght = random_strenght
	
	position.x = move_toward(position.x, random_offset.x, shake_fade * delta)
	position.y = move_toward(position.y, random_offset.y, shake_fade * delta)
	if is_equal_approx(position.x, random_offset.x) and is_equal_approx(position.y, random_offset.y):
		_calculate_random_offset()


func _calculate_random_offset() -> void:
	random_offset = Vector3(rng.randf_range(
		-shake_strenght, shake_strenght), 
		rng.randf_range(-shake_strenght, shake_strenght), 
		0
		)


func reset_offset(delta) -> void:
	position.x = move_toward(position.x, 0, shake_fade * delta)
	position.y = move_toward(position.y, 0, shake_fade * delta)


func random_shake():
	# Define la intensidad del jitter para cada eje
	var jitter_strength = 9  # Radianes	
	
	var random_rotation = get_random_rotation(jitter_strength)
	
	var new_body_rotation = player.rotation_degrees + random_rotation
	new_body_rotation.x = 0
	new_body_rotation.z = 0
	var new_pivot_rotation = camera_pivot.rotation_degrees + random_rotation
	new_pivot_rotation.y = 0
	new_pivot_rotation.z = 0
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		camera_pivot, 
		"rotation_degrees",
		new_pivot_rotation,
		0.006).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(
		player, 
		"rotation_degrees",
		new_body_rotation,
		0.006).set_ease(Tween.EASE_IN_OUT)


func weapon_recoil() -> void:
	var jitter_strength = 0.33  # Radianes
	camera_pivot.rotate_x(jitter_strength)
	camera_pivot.rotation_degrees.x = clampf(
		player.camera_pivot.rotation_degrees.x, -90.0, 70.0)


func get_random_rotation(jitter_strength: float) -> Vector3:
	# Genera valores aleatorios de rotación dentro del rango [-jitter_strength, jitter_strength]
	var random_rotation = Vector3(
		rng.randf_range(-jitter_strength, jitter_strength),  # Rotación alrededor del eje X
		rng.randf_range(-jitter_strength, jitter_strength),  # Rotación alrededor del eje Y
		rng.randf_range(-jitter_strength, jitter_strength)   # Rotación alrededor del eje Z
	)
	return random_rotation


func _on_aim_shake_timer_timeout():
	if not shaking:
		return
	
	aim_shake_timer.wait_time = rng.randf_range(2.0, 0.6)
	random_shake()
