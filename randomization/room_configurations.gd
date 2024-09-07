extends Node3D
class_name RoomConfigurations

signal ConfigurationRandomized

@onready var configurations := get_children()
var selected_configuration : Node3D


func randomize_configuration() -> void:
	configurations.shuffle()
	selected_configuration = configurations.pop_front() as Node3D
	selected_configuration.visible = true
	
	for item in configurations:
		item.queue_free()
	
	ConfigurationRandomized.emit()
