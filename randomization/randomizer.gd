extends Marker3D
class_name Randomizer

signal finish_randomization

@export var randomize_at_ready := false


func _ready() -> void:
	if randomize_at_ready:
		start_randomization()


func start_randomization() -> void:
	pass
