extends Node
class_name EnemyManager

@export var max_enemies_on_level := 12
@export var spawn_frecuency := 15.0
@export var enemies_on_load : int

@onready var spawner_timer: Timer = $SpawnerTimer

var enemy_list : Array[Enemy] = []
var spawn_blockers : Array
var spawners : Array[EnemySpawner] = []

const INFANTICIDE = preload("res://Enemy/infanticide/infanticide.tscn")


func _ready() -> void:
	for i in enemies_on_load:
		request_spawn()


func _can_spawn_enemy() -> bool:
	if enemy_list.size() < max_enemies_on_level and spawn_blockers.is_empty():
		return true
	return false


func kill_all_enemies() -> void:
	for enemy in enemy_list:
		enemy.enemy_die()


func request_spawn() -> void:
	if not _can_spawn_enemy():
		return
	if not spawners.pick_random().spawn(true):
		await get_tree().physics_frame
		request_spawn()


func _on_spawner_timer_timeout() -> void:
	pass # Replace with function body.


func _on_enemies_state_checker_timeout() -> void:
	if spawner_timer.time_left > 0:
		request_spawn()
		spawner_timer.start(spawn_frecuency)
