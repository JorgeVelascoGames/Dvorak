extends PlayerState
class_name PlayerIdle

@onready var world_camera = $"../../CameraPivot/WorldCamera"

@export var aim_multiplier: float = 0.3

#Private variables
var mouse_motion := Vector2.ZERO


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
		player.velocity.x *= aim_multiplier
		player.velocity.z *= aim_multiplier
	
	player.move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001
		if Input.is_action_pressed("aim"):
			mouse_motion *= aim_multiplier / 2


func handle_camera_rotation(_delta:float) -> void:
	player.rotate_y(mouse_motion.x * player.camera_sensibility)
	player.camera_pivot.rotate_x(mouse_motion.y * player.camera_sensibility)
	player.camera_pivot.rotation_degrees.x = clampf(
		player.camera_pivot.rotation_degrees.x, -90.0, 90)
	mouse_motion = Vector2.ZERO


func exit() -> void:
	world_camera.shaking = false
