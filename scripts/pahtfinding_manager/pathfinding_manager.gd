extends Node

var player : Player 
var player_position: Vector3

@onready var timer = $Timer


func set_up_player(current_player: Player) -> void:
	player = current_player


func _on_timer_timeout():
	if player:
		player_position = player.global_position
