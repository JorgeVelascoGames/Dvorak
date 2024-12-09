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
		state_machine.transition_to("PrepareGun", {})


func physics_update(delta: float) -> void:
	handle_camera_rotation(delta)

	if player.direction(delta) != Vector3.ZERO:
		state_machine.transition_to("Walk", {})
		return
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	player.move_and_slide()


func input(event):
	if event.is_action_pressed("interact"):
		player.interact()
	
	if event.is_action_pressed("drop_walker"):
		player.try_grab_walker()
	
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001


func interact() -> void:
	if not player.interactable_ray.is_colliding():
		return
	
	print(player.interactable_ray.get_collider())
	for child in player.interactable_ray.get_collider().get_children():
		if child is Interactable:
			if child.long_interaction:
				state_machine.transition_to("PlayerLongInteraction", {"object" : child})
			else:
				child.interact()


func handle_camera_rotation(_delta:float) -> void:
	player.rotate_y(mouse_motion.x * player.camera_sensibility)
	player.camera_pivot.rotate_x(mouse_motion.y * player.camera_sensibility)
	player.camera_pivot.rotation_degrees.x = clampf(
		player.camera_pivot.rotation_degrees.x, -90.0, 90)
	mouse_motion = Vector2.ZERO
