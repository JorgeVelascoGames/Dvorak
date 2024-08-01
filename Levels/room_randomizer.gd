extends Node3D
class_name RoomRandomizer

signal RoomsRandomized

@export var room_configurations : Array[RoomConfigurations] = []


func randomize_rooms() -> void:
	for configuration in room_configurations:
		configuration.randomize_configuration()
		await configuration.ConfigurationRandomized
	
	RoomsRandomized.emit()
