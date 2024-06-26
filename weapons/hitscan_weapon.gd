class_name Hitscan
extends Node3D

@export var automatic: bool = false
@export var ammo_type: AmmoHandler.ammo_type
@export var weapon_damage: int = 10
@export var fire_rate :float = 14.0
@export var recoil :float = 0.05
@export var weapon_mesh : Node3D
@export var muzzle_flash: GPUParticles3D
@export var sparks: PackedScene

var ammo_handler: AmmoHandler

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var weapon_mesh_init_position : Vector3 = weapon_mesh.position
@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var shoot_sound = $ShootSound


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if automatic:
		if Input.is_action_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	else:
		if Input.is_action_just_pressed("fire"):
			if cooldown_timer.is_stopped():
				shoot()
	weapon_mesh.position = weapon_mesh.position.lerp(weapon_mesh_init_position, delta * 10.0)


func shoot() -> void:
	if not ammo_handler.use_ammo(ammo_type):
		return
	muzzle_flash.restart()
	weapon_mesh.position.z += recoil
	cooldown_timer.start(1.0/ fire_rate)
	shoot_sound.play()
	
	var collider = ray_cast_3d.get_collider()
	if collider == null:
		return
	for child in collider.get_children():
		if child is Health:
			child.damage(weapon_damage)
	
	var spark = sparks.instantiate()
	add_child(spark)
	spark.global_position = ray_cast_3d.get_collision_point()
