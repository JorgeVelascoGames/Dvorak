extends Node

var player : Player 
var player_position: Vector3

@onready var timer = $Timer
@onready var waypoints := get_tree().get_nodes_in_group("Waypoints")


func _ready() -> void:
	for point in waypoints:
		print(point)


func set_up_player(current_player: Player) -> void:
	player = current_player


func _on_timer_timeout():
	if AppManager.game_manager == null:
		return
	if AppManager.game_manager.current_app_state != GameManager.APP_STATE.game:
		player = null
	if player:
		player_position = player.global_position


func get_random_waypoint(last_waypoint : Marker3D = null) -> Marker3D:
	var new_array = waypoints
	
	if last_waypoint:
		new_array.erase(last_waypoint)
	
	var selected = new_array.pick_random() as Marker3D
	return selected
