extends Node
class_name Interactable

signal on_interact


func interact() -> void:
	on_interact.emit()
