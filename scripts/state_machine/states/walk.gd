extends PlayerState
class_name Walk

#Private variables
var mouse_motion := Vector2.ZERO

@onready var world_camera = $"../../CameraPivot/WorldCamera"

@export var aim_multiplier: float = 0.3


func enter(_msg : ={}) -> void:
	pass


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
		player.velocity.x = direction.x * player.speed
		player.velocity.z = direction.z * player.speed
	else:
		state_machine.transition_to("Idle", {})
	if Input.is_action_pressed("aim"):
		state_machine.transition_to("PrepareGun", {})
	
	player.move_and_slide()


func input(event):
	if event.is_action_pressed("interact"):
		player.interact()
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001


func handle_camera_rotation(_delta:float) -> void:
	player.rotate_y(mouse_motion.x * player.camera_sensibility)
	player.camera_pivot.rotate_x(mouse_motion.y * player.camera_sensibility)
	player.camera_pivot.rotation_degrees.x = clampf(
		player.camera_pivot.rotation_degrees.x, -90.0, 90)
	mouse_motion = Vector2.ZERO


func exit() -> void:
	pass
