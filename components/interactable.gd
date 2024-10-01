extends Node
class_name Interactable

signal on_interact
signal on_long_interact

@export var long_interaction := false


func interact() -> void:
	on_interact.emit()


func long_interact() -> void:
	on_long_interact.emit()
