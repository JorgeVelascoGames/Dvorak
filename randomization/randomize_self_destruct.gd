extends Randomizer
##This class adds a chance for its parent to be deleted on ready. Always works on ready. Doesnt emit signal when completed
class_name RandomizeSelfDestruction

@export_range(0.0, 1.0) var chance_to_destroy := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() < chance_to_destroy:
		get_parent().queue_free()
