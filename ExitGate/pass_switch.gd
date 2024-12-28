extends StaticBody3D
class_name PassSwitch

@onready var activated_light: OmniLight3D = $ActivatedLight
@onready var deactivate_light: OmniLight3D = $DeactivateLight

#Exported variables
@export var switch_index : int

#Variables
var switch_active := false


func _on_interactable_on_interact():
	switch_active = !switch_active
	
	if switch_active:
		activated_light.show()
		deactivate_light.hide()
	else:
		activated_light.hide()
		deactivate_light.show()
