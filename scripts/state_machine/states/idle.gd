extends PlayerState
class_name PlayerIdle

var mouse_motion := Vector2.ZERO


func enter(_msg : ={}) -> void:
	pass


func update(delta):
#Head bob code
#	player._delta += delta
#	var cam_bob = floor(abs(1)+abs(1)) * player._delta * 1
#	var objCam = player.originCamPos + Vector3.UP * sin(cam_bob) * .05
#
#	player.camera_3d.position = player.camera_3d.position.lerp(objCam, delta)
	if Input.is_action_pressed("aim"):
		state_machine.transition_to("Aim", {})


func physics_update(delta: float) -> void:
	handle_camera_rotation(delta)

	if player.direction(delta) != Vector3.ZERO:
		state_machine.transition_to("Walk", {})
		return
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	player.move_and_slide()


func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001
		if Input.is_action_pressed("aim"):
			state_machine.transition_to("Aim", {})


func handle_camera_rotation(_delta:float) -> void:
	player.rotate_y(mouse_motion.x * player.camera_sensibility)
	player.camera_pivot.rotate_x(mouse_motion.y * player.camera_sensibility)
	player.camera_pivot.rotation_degrees.x = clampf(
		player.camera_pivot.rotation_degrees.x, -90.0, 90)
	mouse_motion = Vector2.ZERO
