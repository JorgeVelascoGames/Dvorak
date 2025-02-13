extends Randomizer 
class_name RandomizeDeleter##This class takes a number of elements from a list and delets everything except for one

@export var elements : Array[Node3D] = []


func start_randomization() -> void:
	if elements.size() < 2:
		return
	randomize()
	elements.shuffle()
	elements.pop_back()
	for i in elements.size():
		var item = elements.pop_back()
		item.queue_free()
	await get_tree().process_frame
	finish_randomization.emit()
