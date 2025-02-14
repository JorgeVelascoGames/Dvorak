extends Node3D

@onready var omni_light_3d: OmniLight3D = $LampModel/OmniLight3D
@onready var spot_light_3d: SpotLight3D = $LampModel/SpotLight3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if AppManager.game_manager:
		AppManager.game_manager.on_calamity.connect(on_calamity)


func on_calamity() -> void:
	omni_light_3d.hide()
	spot_light_3d.hide()
