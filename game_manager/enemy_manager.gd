extends Node
class_name EnemyManager

@export var max_enemies_on_level := 12

var enemy_list : Array[Enemy]
var can_spawn := true


func _can_spawn_enemy() -> bool:
	if enemy_list.size() < max_enemies_on_level and can_spawn:
		return true
	return false


func kill_all_enemies() -> void:
	for enemy in enemy_list:
		enemy.enemy_die()
