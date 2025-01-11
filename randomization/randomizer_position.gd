extends Randomizer
class_name RandomizerPosition

@export var item : Node3D

@onready var positions : Array[Node] = get_children()


func start_randomization() -> void:
	randomize()
	positions.shuffle()
	for pos in positions:
		if pos is Node3D:
			item.position = pos.position
			item.rotation = pos.rotation
			break
	finish_randomization.emit()
