extends Node
class_name PositionRandomization

@export var positions : Array[Vector3] = []
@export var item : Node3D


func _ready() -> void:
	item.global_position = positions.pick_random()
