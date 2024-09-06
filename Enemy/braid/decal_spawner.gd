extends Node

##The decal in question. This node will get disabled if this is not a decal
@export var decal : PackedScene
##If timer is greater than 0, the spawner will loop base on said timer
@export var spawn_decal_on_timer := 0.0
##If the spawner stars working on ready
@export var start_spawn_on_ready := false

@onready var timer: Timer = $Timer


func _ready() -> void:
	if start_spawn_on_ready:
		spawn_decal()


func spawn_decal(position : Vector3 = self.global_position):
	var new_decal : Decal = decal.instantiate() as Decal
	new_decal.top_level = true
	add_child(new_decal)
	new_decal.rotate_y(randf() * 50.0)
	new_decal.global_position = position
	if spawn_decal_on_timer > 0:
		timer.start(spawn_decal_on_timer)


func _on_timer_timeout() -> void:
	spawn_decal()
