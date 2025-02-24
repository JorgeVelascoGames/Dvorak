class_name Enemy
extends CharacterBody3D

##The speed movement of the enemy. If there is a player on scene, this will become the speed of the player without walker +0.2
@export var speed := 7.0 
@export var attack_range:= 1.5
@export var is_active:= true
@export var provoke_on_ready := true
@export var aggro_range := 12.0
##If true, the model will always face the player rotation on the Y direction
@export var always_face_player := true

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D
@onready var enemy_audio_manager: EnemyAudioManager = $EnemyAudioManager
@onready var enemy_animation: EnemyAnimator = $EnemyAnimation
@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var model: Node3D = $Model
@onready var enemy_manager : EnemyManager = get_tree().get_first_node_in_group("enemy_manager")

var current_target
var provoke := false
var can_move := true
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	await get_tree().process_frame
	if enemy_manager:
		get_tree().get_first_node_in_group("enemy_manager").enemy_list.append(self)
	reparent(AppManager.game_manager.current_level_manager.enemy_container)
	model.top_level = true
	if provoke_on_ready:
		provoke = true
	
	apply_floor_snap()
	
	if player == null:
		is_active = false
		return
	
	speed = player.speed + 0.2


func _process(_delta: float) -> void:
	model.global_position = global_position
	model.rotation.y = rotation.y
	
	if not is_active:
		return
	if not can_move:
		return
	if provoke:
		navigation_agent_3d.target_position = PathfindingManager.player_position


func _physics_process(_delta: float) -> void:
	# Add the gravity.
	if not is_on_floor(): 
		velocity.y -= gravity * _delta
	if not is_active:
		return
	if not can_move:
		return
	movement_process(_delta);


func movement_process(_delta: float) -> void:
	if provoke:
		current_target = player
	
	if current_target == null:
		return
	
	var next_position = navigation_agent_3d.get_next_path_position()
	
	if always_face_player:
		look_at(current_target.global_position) #Dont need to lock rotation arround X because its already locked on the character controller
	else:
		look_at(next_position)
	
	var direction = global_position.direction_to(next_position)
	
	
	
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
	$Model.hide()
	if enemy_manager:
		enemy_manager.enemy_list.erase(self)
	queue_free()


func _on_hurt_box_body_entered(body: Node3D) -> void:
	if body is Player:
		$HurtBox.monitoring = false
		body.player_health.player_hit()
		enemy_die()
		for enemy_body in $DetectionArea.get_overlapping_bodies():
			if enemy_body is Enemy:
				enemy_body.enemy_die(false)


func _on_aggro_area_body_entered(body: Node3D) -> void:
	if body is Player:
		provoke = true
