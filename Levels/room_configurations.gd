extends Node
class_name RoomConfigurations

signal ConfigurationRandomized

@export var configurations : Array[Node3D] = []
var selected_configuration : Node3D


func randomize_configuration() -> void:
	configurations.shuffle()
	selected_configuration = configurations.pop_front() as Node3D
	selected_configuration.visible = true
	
	for item in configurations:
		item.queue_free()
	
	ConfigurationRandomized.emit()
