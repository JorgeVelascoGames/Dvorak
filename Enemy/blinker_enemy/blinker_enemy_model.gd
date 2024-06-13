extends Node3D

@export var max_blink_timer := 6.0 
@export var min_blink_timer := 3.7

@onready var blinker_enemy = $".."
@onready var blink_timer = $BlinkTimer


func blink() -> void:
	global_position = blinker_enemy.position
	var new_blink_timer : float = next_blink_timer()
	blink_timer.start(new_blink_timer)


func next_blink_timer() -> float:
	var blink_time := randf_range(min_blink_timer, max_blink_timer)
	return blink_time


func _on_blink_timer_timeout():
	blink()


func _on_area_3d_body_entered(body):
	if body is Player:
		blinker_enemy.enemy_die()
		pass #hit the player
