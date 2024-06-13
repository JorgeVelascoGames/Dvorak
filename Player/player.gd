extends CharacterBody3D
class_name Player

@export var speed = 3.0
@export var fall_multiplier: float = 2.5
@export var camera_sensibility: float = 1.2
@export var can_jump: bool = true

@export_group("Miscelanea")
@export var camBobSpeed := 4
@export var camBobUpDown := 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Components
@onready var camera_pivot = $CameraPivot
@onready var damage_animation_player: AnimationPlayer = $DamageTexture/DamageAnimationPlayer
@onready var game_over_menu: Control = $GameOverMenu
@onready var world_camera: Camera3D = $CameraPivot/WorldCamera
@onready var original_world_camera_fov = world_camera.fov
@onready var weapon_camera: Camera3D = $SubViewportContainer/SubViewport/WeaponCamera
@onready var original_weapon_camera_fov = weapon_camera.fov
@onready var state_machine = $StateMachine
@onready var originCamPos : Vector3 = camera_pivot.position
@onready var interactable_ray = $CameraPivot/WorldCamera/InteractableRay

var _delta := 0.0


func _ready():
	apply_floor_snap()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	PathfindingManager.set_up_player(self)


func _process(delta: float) -> void:
	_delta += delta
	if _delta > 10:
		delta = 0


func _physics_process(delta):
	# Add the gravity.
	process_gravity(delta)
	move_and_slide()


func direction(_delta) -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return direction


func process_gravity(delta):
	if not is_on_floor():
		if velocity.y >=0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier


func interact() -> void:
	if not interactable_ray.is_colliding():
		return
	
	print(interactable_ray.get_collider())
	for child in interactable_ray.get_collider().get_children():
		if child is Interactable:
			child.interact()


func player_hit() -> void:
	game_over_menu.game_over()


func _on_interactable_on_interact():
	state_machine.transition_to("Walker", {})
