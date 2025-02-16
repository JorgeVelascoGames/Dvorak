extends Node
class_name EnemyManager

@export var max_enemies_on_level := 12
@export var spawn_frecuency := 15.0
@export var initial_delay := 20.0
@export var no_enemies := false

@onready var spawner_timer: Timer = $SpawnerTimer

var can_spawn := false
var enemy_list : Array[Enemy] = []
##While there is something in this array, nothing will spawn
var spawn_blockers : Array
var spawners : Array[EnemySpawner] = []

const INFANTICIDE = preload("res://Enemy/infanticide/infanticide.tscn")


func start_level() -> void:
	await get_tree().process_frame
	if no_enemies:
		return
	
	AppManager.game_manager.on_calamity.connect(on_calamity)
	await get_tree().create_timer(initial_delay).timeout
	$EnemiesStateChecker.start()


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
	spawners.pick_random().spawn(true)


func on_calamity() -> void:
	spawn_frecuency /=3
	max_enemies_on_level *= 2


func _on_spawner_timer_timeout() -> void:
	pass # Replace with function body.


func _on_enemies_state_checker_timeout() -> void:
	if spawner_timer.is_stopped():
		request_spawn()
		spawner_timer.start(spawn_frecuency)
