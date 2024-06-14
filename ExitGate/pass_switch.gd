extends MeshInstance3D
class_name PassSwitch

#Exported variables
@export var switch_index : int

#Variables
var switch_active := false


func _on_interactable_on_interact():
	switch_active = !switch_active
