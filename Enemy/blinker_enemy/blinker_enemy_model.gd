extends Node3D
class_name BlinkerBody

@export var max_blink_timer := 6.0 
@export var min_blink_timer := 3.7

@onready var blinker_enemy = $".."
@onready var blink_timer = $BlinkTimer


func blink() -> void:
	global_position = blinker_enemy.position
	global_position.x += randf_range(-1.5, 1.5)
	look_at(blinker_enemy.player.global_position)
	var new_blink_timer : float = next_blink_timer()
	blink_timer.start(new_blink_timer)


func next_blink_timer() -> float:
	var blink_time := randf_range(min_blink_timer, max_blink_timer)
	return blink_time


func enemy_die() -> void:
	blinker_enemy.enemy_die()


func _on_blink_timer_timeout():
	blink()


func _on_area_3d_body_entered(body):
	if body is Player:
		blinker_enemy.enemy_die()
		body.player_hit()
