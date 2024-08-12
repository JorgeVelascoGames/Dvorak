extends PlayerState
class_name Walker

@export var speed := 0.3
@export var rotation_speed := 0.2

@onready var world_camera = $"../../CameraPivot/WorldCamera"
@onready var camera_pivot = $"../../CameraPivot"
@onready var walker: MeshInstance3D = $"../../WalkerFixedPoint/Walker"
@onready var player_collision_shape: CollisionShape3D = $"../../PlayerCollisionShape"
@onready var ammo_handler = $"../Aim/AmmoHandler"

const PLAYER_NORMAL_COLLISION_SHAPE = preload("res://player/player_normal_collision_shape.tres")
const PLAYER_WALKER_COLLISION_SHAPE = preload("res://player/player_walker_collision_shape.tres")
#Private variables
var mouse_motion := Vector2.ZERO
var rotation_acelerator := 0.0
var default_floor_max_angle : float


func enter(_msg : ={}) -> void:
	ammo_handler.reload()
	default_floor_max_angle = player.floor_max_angle
	player.floor_max_angle = 0
	#player_collision_shape.shape = PLAYER_WALKER_COLLISION_SHAPE
	camera_pivot.rotation = Vector3.ZERO
	player.velocity = Vector3.ZERO
	walker.grab_walker()


func update(delta):
	pass


func physics_update(delta: float) -> void:	
	var direction := (player.transform.basis * Vector3.FORWARD).normalized()
	if Input.is_action_pressed("move_forward"):
		#player.velocity.z = direction.z * speed
		#player.velocity.x = direction.x * speed
		player.velocity.z = move_toward(player.velocity.z, direction.z * speed, speed / 80)
		player.velocity.x = move_toward(player.velocity.x, direction.x * speed, speed / 80)
		if is_equal_approx(player.velocity.z, direction.z * speed) and is_equal_approx(player.velocity.x, direction.x * speed):
			player.velocity.z = 0
			player.velocity.x = 0
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		rotation_acelerator += delta
		print(rotation_acelerator)
		player.rotate_y(rotation_speed * rotation_acelerator * 
		-Input.get_vector("move_left", "move_right", "move_forward", "move_back").x  * delta)
		if rotation_acelerator >= 1.0:
			rotation_acelerator = 0.0
	
	if Input.is_action_just_released("move_forward"):
		player.velocity.z = move_toward(player.velocity.z, 0, speed)
		player.velocity.x = move_toward(player.velocity.x, 0, speed)
	
	handle_camera_rotation(delta)
	player.move_and_slide()


func input(event):
	if event.is_action_pressed("interact"):
		player.interact()
	if event is InputEventMouseMotion:
		mouse_motion = -event.relative * 0.001
	if event.is_action_pressed("drop_walker"):
		state_machine.transition_to("Walk", {})


func handle_camera_rotation(_delta:float) -> void:
	camera_pivot.rotate_y(mouse_motion.x * player.camera_sensibility)
	camera_pivot.rotate_x(mouse_motion.y * player.camera_sensibility)
	camera_pivot.rotation.z = 0
	#camera_pivot.rotate_object_local(Vector3.UP, mouse_motion.x * player.camera_sensibility)
	#camera_pivot.rotate_object_local(Vector3.RIGHT, mouse_motion.y * player.camera_sensibility)
	camera_pivot.rotation_degrees.x = clampf(
		camera_pivot.rotation_degrees.x, -15.0, 15)
	camera_pivot.rotation_degrees.y = clampf(
		camera_pivot.rotation_degrees.y, -25.0, 25)
	mouse_motion = Vector2.ZERO


func rotate_with_mouse(_delta, _object):
	pass


func exit() -> void:
	player.floor_max_angle = default_floor_max_angle
	camera_pivot.rotation = Vector3.ZERO
	player_collision_shape.shape = PLAYER_NORMAL_COLLISION_SHAPE
	walker.free_walker()
