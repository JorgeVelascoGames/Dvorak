extends Randomizer 
##This class takes a number of elements from a list and delets everything except for one
class_name RandomizeDeleter

@export var elements : Array[Node3D] = []


func start_randomization() -> void:
	randomize()
	elements.shuffle()
	elements.pop_back()
	for i in elements.size():
		var item = elements.pop_back()
		item.queue_free()
	await get_tree().process_frame
	finish_randomization.emit()
