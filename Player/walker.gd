extends MeshInstance3D

@onready var static_body_3d: StaticBody3D = $StaticBody3D


func free_walker() -> void:
	layers = 1
	static_body_3d.process_mode = Node.PROCESS_MODE_INHERIT
	top_level = true


func grab_walker() -> void:
	layers = 2
	static_body_3d.process_mode = Node.PROCESS_MODE_DISABLED
	top_level = false
	position = Vector3.ZERO
	rotation = Vector3.ZERO
