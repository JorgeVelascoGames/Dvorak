extends Node

@export var decal : PackedScene
@export var spawn_decal_on_timer := 0.0

@onready var timer: Timer = $Timer


func _ready() -> void:
	if spawn_decal_on_timer > 0:
		timer.start(spawn_decal_on_timer)
		spawn_decal()


func spawn_decal(position : Vector3 = self.global_position):
	var new_decal = decal.instantiate()
	new_decal.top_level = true
	add_child(new_decal)
	new_decal.global_position = position


func _on_timer_timeout() -> void:
	spawn_decal()
