class_name Enemy
extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_audio_manager: EnemyAudioManager = $EnemyAudioManager
@onready var enemy_animation: EnemyAnimator = $EnemyAnimation

@export var speed = 7.0
@export var attack_range: float = 1.5
@export var is_active: bool = true

var player : Player = get_tree().get_first_node_in_group("player")
var provoke := false
var can_move := true
@export var aggro_range := 12.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	apply_floor_snap()


func _process(_delta: float) -> void:
	if not is_active:
		return
	if not can_move:
		return
	if provoke:
		navigation_agent_3d.target_position = PathfindingManager.player_position


func _physics_process(_delta: float) -> void:
	if not is_active:
		return
	if not can_move:
		return
	movement_process(_delta);


func movement_process(_delta: float) -> void:
	var current_target
	
	if provoke:
		current_target = player
	
	var distance = global_position.distance_to(current_target.global_position)
	var next_position = navigation_agent_3d.get_next_path_position()
	look_at(current_target)
	var direction = global_position.direction_to(next_position)
	
	if distance < aggro_range:
		provoke = true
	
	# Add the gravity.
	if not is_on_floor(): 
		velocity.y -= gravity * _delta
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()


func enemy_die() -> void:
	is_active = false
	enemy_audio_manager.play_dead_audio()
	await enemy_animation.play_dead_animation()
	queue_free()


func enemy_banish() -> void:
	is_active = false
	enemy_audio_manager.play_sfx()
	await enemy_animation.play_banish_animation()
	queue_free()


func _on_health_taken_damage(_dmg: int) -> void:
	if is_active:
		enemy_die()


func _on_collision_detection_body_entered(body):
	if body is Player:
		can_move = false
		body.player_hit()
		enemy_banish()
