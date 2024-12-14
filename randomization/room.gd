extends Node3D
class_name Room

@export var atril_spawn_point : Marker3D
@export var item_spawning_points : Array[Marker3D]
@export var cross: Node3D #Salve Cristo Rey


func _ready() -> void:
	if not atril_spawn_point or not item_spawning_points or not cross:
		push_warning("This room is not complete")
