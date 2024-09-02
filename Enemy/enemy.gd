class_name Enemy
extends CharacterBody3D

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_damage_audio = $EnemyDamageAudio
@onready var enemy_dead_audio = $EnemyDeadAudio
@onready var enemy_audio = $EnemyAudio

@export var speed = 7.0
@export var attack_range: float = 1.5
@export var is_active: bool = true

var player : Player
var provoke := false
var can_move := true
var current_waypoint : Marker3D
@export var aggro_range := 12.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	apply_floor_snap()
	player = get_tree().get_first_node_in_group("player")
	
	await get_tree().process_frame
	current_waypoint = PathfindingManager.get_random_waypoint()


func _process(_delta: float) -> void:
	if not is_active:
		return
	if not can_move:
		return
	if provoke:
		navigation_agent_3d.target_position = PathfindingManager.player_position
	else:
		roam()


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
	else:
		current_target = current_waypoint
	
	var distance = global_position.distance_to(current_target.global_position)
	var next_position = navigation_agent_3d.get_next_path_position()
	look_at(next_position)
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


func attack() -> void:
	player.health.damage(10)
	print("Enemy Attack!");


func enemy_die() -> void:
	enemy_damage_audio.process_mode = Node.PROCESS_MODE_DISABLED
	enemy_audio.process_mode = Node.PROCESS_MODE_DISABLED
	is_active = false
	enemy_dead_audio.play()
	const DEAD_DELAY := 1.4
	await get_tree().create_timer(DEAD_DELAY).timeout
	queue_free()


func _on_health_health_minimun_reached() -> void:
	enemy_die()


func _on_health_taken_damage(_dmg: int) -> void:
	enemy_die()


func roam():
	if current_waypoint == null or global_position.distance_to(current_waypoint.global_position) < 0.5:
		current_waypoint = PathfindingManager.get_random_waypoint(current_waypoint)


func _on_collision_detection_body_entered(body):
	if body is Player:
		can_move = false
		body.player_hit()
		enemy_die()


func _on_collision_detection_body_exited(body):
	if body is Player:
		can_move = true
