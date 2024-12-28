extends Node
class_name EnemyManager

@export var max_enemies_on_level := 12
@export var spawn_frecuency := 15.0

@onready var spawner_timer: Timer = $SpawnerTimer

var enemy_list : Array[Enemy]
var spawn_blockers : Array
var spawners : Array[EnemySpawner]


func _can_spawn_enemy() -> bool:
	if enemy_list.size() < max_enemies_on_level and spawn_blockers.is_empty():
		return true
	return false


func kill_all_enemies() -> void:
	for enemy in enemy_list:
		enemy.enemy_die()


func request_spawn() -> void:
	pass


func _on_spawner_timer_timeout() -> void:
	pass # Replace with function body.


func _on_enemies_state_checker_timeout() -> void:
	if spawner_timer.time_left > 0:
		request_spawn()
		spawner_timer.start(spawn_frecuency)
