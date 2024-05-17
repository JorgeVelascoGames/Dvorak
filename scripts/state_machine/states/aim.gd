extends PlayerState
class_name PlayerAim

@onready var world_camera = $"../../CameraPivot/WorldCamera"
@onready var sensibility_timer = $SensibilityTimer

@export var aim_multiplier: float = 0.3
@export var aim_speed: float = 0.5
var jitter_strength: float = 0.005

#Private variables
var mouse_motion := Vector2.ZERO
var rng = RandomNumberGenerator.new()
var randomized_sensibility: float = 1.0

func enter(_msg : ={}) -> void:
	player.velocity = Vector3.ZERO
	world_camera.shaking = true


func update(delta):
	if Input.is_action_just_released("aim"):
		state_machine.transition_to("Idle", {})


func physics_update(delta: float) -> void:
	handle_camera_rotation(delta)
	var direction = player.direction(delta)
	if direction:
		player.velocity.x = direction.x * aim_speed
		player.velocity.z = direction.z * aim_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
		player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	player.move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		var random_jitter = Vector2(
		rng.randf_range(-jitter_strength, jitter_strength), 
		rng.randf_range(-jitter_strength, jitter_strength)
		)
		mouse_motion = -event.relative * 0.001
		mouse_motion *= aim_multiplier / 2
		mouse_motion += random_jitter


func handle_camera_rotation(_delta:float) -> void:
	player.rotate_y(mouse_motion.x * randomized_sensibility)
	player.camera_pivot.rotate_x(mouse_motion.y * randomized_sensibility)
	player.camera_pivot.rotation_degrees.x = clampf(
		player.camera_pivot.rotation_degrees.x, -90.0, 90)
	mouse_motion = Vector2.ZERO


func exit() -> void:
	world_camera.shaking = false
	player.camera_pivot.rotation.z = 0


func _on_sensibility_timer_timeout():
	randomized_sensibility = player.camera_sensibility * rng.randf_range(0.1, 3.0)
