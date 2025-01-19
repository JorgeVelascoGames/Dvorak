extends CharacterBody3D
class_name Player

#Exported variables
@export_category("Movement")
@export var speed = 3.0
@export var fall_multiplier: float = 2.5
@export var camera_sensibility: float = 1.2
@export var can_jump: bool = true

@export_category("Health")
@export var damaged := false
@export var time_to_heal_up := 30.0

@export_group("Miscelanea")
@export var camBobSpeed := 4
@export var camBobUpDown := 0.1

#Variables
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var _delta := 0.0

enum WEAPON {none, gun, crowbar, flashlight}
var current_weapon : WEAPON = WEAPON.none

#Components
@onready var camera_pivot = $CameraPivot
@onready var world_camera: Camera3D = $CameraPivot/FollowPivot/WorldCamera
@onready var weapon_camera: Camera3D = $SubViewportContainer/SubViewport/WeaponCamera
@onready var state_machine = $StateMachine
@onready var interactable_ray = $CameraPivot/FollowPivot/WorldCamera/InteractableRay
@onready var damaged_heal_timer = $Timers/DamagedHealTimer
@onready var player_ui: PlayerUI = $PlayerUI
@onready var walker: WalkerModel = $WalkerFixedPoint/Walker
@onready var ammo_counter: AmmoCounter = $Components/AmmoCounter
@onready var inventory: Inventory = $Components/Inventory
@onready var flashlight_pivot: Node3D = $FlashlightPivot
@onready var flashlight : Flashlight = walker.flashlight

#onready variables
@onready var original_world_camera_fov = world_camera.fov
@onready var original_weapon_camera_fov = weapon_camera.fov

var originCamPos : Vector3
var states_with_interact := ["Idle", "Walk"]
var current_interactable_hint : Hint


func _ready():
	apply_floor_snap()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	PathfindingManager.set_up_player(self)
	await get_tree().physics_frame
	originCamPos = camera_pivot.position #Esta posición la marca la animación "no movement pivot"


func _process(delta: float) -> void:
	_delta += delta
	if _delta > 10:
		delta = 0
	#Scan raycast for hints
	if interactable_ray.is_colliding() and states_with_interact.has(state_machine.state.name):
		var collision = interactable_ray.get_collider()
		for child in collision.get_children():
			if child is Interactable:
				player_ui.add_interaction_hint(child.interactable_hint)
				if current_interactable_hint != child.interactable_hint:
					player_ui.hide_interaction_hint(current_interactable_hint) #Just to make sure all hints are removed from the array in case there is some problem
				current_interactable_hint = child.interactable_hint
				return
	player_ui.hide_interaction_hint(current_interactable_hint)


func _physics_process(delta):
	# Add the gravity.
	process_gravity(delta)
	move_and_slide()


func direction(delta) -> Vector3:
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var new_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	return new_direction


func process_gravity(delta):
	if not is_on_floor():
		if velocity.y >=0:
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * fall_multiplier


func interact() -> void:
	state_machine.state.interact()


func try_grab_walker():
	walker.try_pick_walker()


func player_hit() -> void:
	if damaged:
		pass#TODO
	else:
		damaged = true
		damaged_heal_timer.start(time_to_heal_up)


func heal_up() -> void:
	damaged = false
	damaged_heal_timer.stop()


func _on_damaged_heal_timer_timeout():
	heal_up()


func pick_up_flashlight() -> void:
	flashlight.move_flashlight(flashlight_pivot)


func toggle_flashlight() -> void:
	if current_weapon == WEAPON.flashlight:
		flashlight.toggle_flashlight()


func _on_walker_walker_interacted() -> void:
	if get_floor_normal().abs().is_equal_approx(Vector3.UP):
		state_machine.transition_to("Walker", {})
