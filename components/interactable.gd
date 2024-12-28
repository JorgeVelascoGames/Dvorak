extends Node
class_name Interactable

signal on_interact
signal on_long_interact

@export var long_interaction := false
@export var necessary_keys_to_press_min := 15
@export var necessary_keys_to_press_max := 25

func interact() -> void:
	on_interact.emit()


func long_interact() -> void:
	on_interact.emit()
	on_long_interact.emit()
