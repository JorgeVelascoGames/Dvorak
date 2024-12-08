extends PlayerState
class_name PlayerAim

@onready var world_camera = $"../../CameraPivot/WorldCamera"
@onready var sensibility_timer = $SensibilityTimer
@onready var balance = $"../../Components/Balance"
@onready var gun_ray : RayCast3D = $"../../CameraPivot/WorldCamera/GunRay"
@onready var ammo_counter: AmmoCounter = $"../../Components/AmmoCounter"
@onready var aiming_gun: Node3D = $"../../SubViewportContainer/SubViewport/WeaponCamera/GunModel"

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
	aiming_gun.visible = true
	#small animation...
	var initial_gun_pos := aiming_gun.position
	aiming_gun.global_position.y -= .4
	var tween = create_tween()
	tween.tween_property(aiming_gun, "position", initial_gun_pos, 0.3)

func update(_delta):
	if Input.is_action_just_released("aim"):
		state_machine.transition_to("Idle", {})


func physics_update(delta: float) -> void:
	handle_camera_rotation(delta)
	player.move_and_slide()


func input(event):
	if event.is_action_pressed("fire"):
		fire()
	
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
		player.camera_pivot.rotation_degrees.x, -90.0, 60)
	mouse_motion = Vector2.ZERO


func exit() -> void:
	world_camera.shaking = false
	var tween = create_tween()
	var original_pos := aiming_gun.position
	var new_pos := Vector3(aiming_gun.position.x, aiming_gun.position.y - 0.4, aiming_gun.position.z)
	tween.tween_property(aiming_gun, "position", new_pos, 0.3)
	await tween.finished
	aiming_gun.position = original_pos
	player.camera_pivot.rotation.z = 0
	aiming_gun.visible = false


func fire() -> void:
	if ammo_counter.try_fire_shot() == false:
		state_machine.transition_to("Idle", {})
		#Sound
		return
	
	world_camera.weapon_recoil()
	balance.add_balance(balance.shooting_cost)
	print(gun_ray.get_collider())
	if gun_ray.is_colliding() and gun_ray.get_collider().owner is Enemy:
		gun_ray.get_collider().owner.enemy_die()


func _on_sensibility_timer_timeout():
	randomized_sensibility = player.camera_sensibility * rng.randf_range(0.1, 3.0)
