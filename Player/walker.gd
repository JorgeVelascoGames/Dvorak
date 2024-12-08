extends Node3D
class_name WalkerModel

signal WalkerInteracted

@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var free_walker_position = $FreeWalkerPosition
@onready var flashlight: SpotLight3D = $Flashlight
@onready var walker_model: MeshInstance3D = $WalkerModel


func flashlight_togle() -> void:
	flashlight.toggle_flashlight()


func free_walker() -> void:
	walker_model.layers = 1
	static_body_3d.process_mode = Node.PROCESS_MODE_INHERIT
	top_level = true
	global_position = free_walker_position.global_position


func grab_walker() -> void:
	walker_model.layers = 2
	static_body_3d.process_mode = Node.PROCESS_MODE_DISABLED
	top_level = false
	position = Vector3.ZERO
	rotation = Vector3.ZERO


func _on_interactable_on_interact() -> void:
	WalkerInteracted.emit()
