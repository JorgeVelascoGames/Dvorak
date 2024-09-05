extends Node3D
class_name EnemySpawnManager

@export var spawn_time_bonus_on_kill := 2.0 ##The amount of seconds that the next enemy spawn timer is reduced (it will make the next spawn happen faster)
@export var base_spawn_cooldown := 20.0 ##The base time between enemy spawns

@onready var enemy_spawn_list : Array[EnemySpawner] = []
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var spawn_timer: Timer = $SpawnTimer
@onready var current_spawn_cd = base_spawn_cooldown


func _ready() -> void:
	for item in get_children():
		enemy_spawn_list.append(item)


func spawn_enemy():
	select_enemy_spawner().spawn()
	spawn_timer.start(current_spawn_cd)


func select_enemy_spawner() -> EnemySpawner:
	var spawner : EnemySpawner
	var max_distance : float
	var min_distance : float
	
	for item in enemy_spawn_list:
		var distance := item.global_position.distance_to(player.global_position)
		if distance > max_distance:
			max_distance = distance
		if distance < min_distance:
			min_distance = distance
	
	var random_number = randf_range(min_distance, max_distance)
	var closest_to_median : float = 9999999999
	
	for item in enemy_spawn_list:
		var distance := item.global_position.distance_to(player.global_position)
		
		if abs(distance - random_number) < closest_to_median:
			spawner = item
		
	return spawner


func on_enemy_die() -> void:
	var remaining_time := spawn_timer.time_left
	var new_bonus_time : float = abs(remaining_time - spawn_time_bonus_on_kill)
	clampf(new_bonus_time, 1.0, new_bonus_time)
	spawn_timer.stop()
	spawn_timer.start(new_bonus_time)


func _on_spawn_timer_timeout() -> void:
	pass #TODO
