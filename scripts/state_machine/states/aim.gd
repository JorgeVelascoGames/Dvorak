extends PlayerState
class_name PlayerAim

@onready var world_camera = $"../../CameraPivot/FollowPivot/WorldCamera"
@onready var sensibility_timer = $SensibilityTimer
@onready var balance = $"../../Components/Balance"
@onready var gun_ray : RayCast3D = $"../../CameraPivot/FollowPivot/WorldCamera/GunRay"
@onready var ammo_counter: AmmoCounter = $"../../Components/AmmoCounter"
@onready var aiming_gun: Node3D = $"../../SubViewportContainer/SubViewport/WeaponCamera/GunModel"
@onready var initial_gun_pos := aiming_gun.position
@onready var prepare_gun: PrepareGun = $"../PrepareGun"
@onready var crosshair: CenterContainer = $"../../PlayerUI/Crosshair"

@export var aim_multiplier: float = 0.3
@export var aim_speed: float = 0.5
var jitter_strength: float = 0.005

#Private variables
var mouse_motion := Vector2.ZERO
var rng = RandomNumberGenerator.new()
var randomized_sensibility: float = 2.0
var tween : Tween

func enter(_msg : ={}) -> void:
	crosshair.hide()
	player.velocity = Vector3.ZERO
	world_camera.shaking = true
	aiming_gun.visible = true
	#small animation...
	aiming_gun.position.y -= .4
	if tween:
		tween.kill()
	tween = create_tween()
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
	crosshair.show()
	world_camera.shaking = false
	if tween:
		tween.kill()
	tween = create_tween()
	var new_pos := Vector3(initial_gun_pos.x, initial_gun_pos.y - 0.4, initial_gun_pos.z)
	tween.tween_property(aiming_gun, "position", new_pos, 0.3)
	await tween.finished
	aiming_gun.position = initial_gun_pos
	player.camera_pivot.rotation.z = 0
	aiming_gun.visible = false


func fire() -> void:
	if ammo_counter.try_fire_shot() == false:
		state_machine.transition_to("Idle", {})
		player.player_audio_manager.gun_out_of_bullets()
		player.player_ui.display_gameplay_text("The gun is unloaded", 2)
		return
	
	player.player_audio_manager.shoot_gun()
	if gun_ray.get_collider():
		var collision = gun_ray.get_collider().owner
		if gun_ray.is_colliding() and collision is Enemy:
			#if collision is InfanticideEnemy:
				#collision.shot_infanticide_enemy()
			gun_ray.get_collider().owner.enemy_die()
			player.player_audio_manager.hit_flesh()
	
	world_camera.weapon_recoil()
	balance.add_balance(balance.shooting_cost)


func _on_sensibility_timer_timeout():
	randomized_sensibility = player.camera_sensibility * rng.randf_range(1.2, 3.0)
