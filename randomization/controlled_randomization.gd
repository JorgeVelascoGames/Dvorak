extends Node
class_name ControlledRandomization

signal RandomizationCompleted

@export var items_to_save : int
@export var randomize_on_ready := false

@onready var items := get_children()


func _ready():
	if randomize_on_ready:
		randomize_list()


func randomize_list(_items_to_save : int = items_to_save):
	if _items_to_save >= items.size():
		print_debug("Items to save is equal or superior to the items in the list")
		RandomizationCompleted.emit()
		return
	
	var delete_item
	items.shuffle()
	for i in _items_to_save:
		delete_item = items.pop_back() as Node
		delete_item.queue_free()
	RandomizationCompleted.emit()
