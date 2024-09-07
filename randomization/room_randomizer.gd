extends Node3D
class_name RoomRandomizer

signal RoomsRandomized

@onready var room_configurations := get_children()


func randomize_rooms() -> void:
	for configuration in room_configurations:
		configuration.randomize_configuration()
	
	RoomsRandomized.emit()
