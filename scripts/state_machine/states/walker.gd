extends PlayerState
class_name Walker


@onready var world_camera = $"../../CameraPivot/WorldCamera"
@onready var camera_pivot = $"../../CameraPivot"


#Private variables
var mouse_motion := Vector2.ZERO

# Sensibilidad de la rotación del mouse
var mouse_sensitivity = Vector2(0.005, 0.005)

# Última posición del mouse registrada
var last_mouse_position = Vector2()


func enter(_msg : ={}) -> void:
	player.velocity = Vector3.ZERO


func update(delta):
	pass
	#if player.direction(delta) == Vector3.ZERO:
		#state_machine.transition_to("Idle", {})
	
#   no head bumb
#	var cam_bob = floor(abs(player.direction.z) + abs(player.direction.x)) * player._delta * player.camBobSpeed
#	var objCam = player.originCamPos + Vector3.UP * sin(cam_bob) * player.camBobUpDown	
#	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	
	#if !player.is_on_floor():
		#state_machine.transition_to("Jump", {})
	#
	#if Input.is_action_just_pressed("jump") and player.can_jump:
		#state_machine.transition_to("Jump", {do_jump = true})


func physics_update(delta: float) -> void:
	handle_camera_rotation(delta)
	var direction = player.direction(delta)
	if direction:
		player.velocity.z = direction.z * player.speed
	player.move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001


func handle_camera_rotation(_delta:float) -> void:
	camera_pivot.rotate_y(mouse_motion.x * player.camera_sensibility)
	camera_pivot.rotate_x(mouse_motion.y * player.camera_sensibility)
	camera_pivot.rotation_degrees.x = clampf(
		player.camera_pivot.rotation_degrees.x, -90.0, 90)
	camera_pivot.rotation_degrees.y = clampf(
		player.camera_pivot.rotation_degrees.x, -90.0, 90)
	mouse_motion = Vector2.ZERO


func rotate_with_mouse(delta, object):
	pass


func exit() -> void:
	pass
