extends MeshInstance3D

@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var free_walker_position = $FreeWalkerPosition
@onready var flashlight: SpotLight3D = $Flashlight


func flashlight_togle() -> void:
	flashlight.visible = !flashlight.visible


func free_walker() -> void:
	layers = 1
	static_body_3d.process_mode = Node.PROCESS_MODE_INHERIT
	top_level = true
	global_position = free_walker_position.global_position


func grab_walker() -> void:
	layers = 2
	static_body_3d.process_mode = Node.PROCESS_MODE_DISABLED
	top_level = false
	position = Vector3.ZERO
	rotation = Vector3.ZERO
