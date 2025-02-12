extends StaticBody3D
class_name PassSwitch

@onready var activated_light: OmniLight3D = $ActivatedLight
@onready var deactivate_light: OmniLight3D = $DeactivateLight
@onready var animation_tree: SwitchAnimation = $swich/AnimationTree
@onready var player_ui : PlayerUI = get_tree().get_first_node_in_group("player_ui")
@onready var audio: AudioStreamPlayer3D = $Audio

#Exported variables
@export var switch_index : int

#Variables
var switch_active := false
var order : String


func _ready() -> void:
	if switch_active:
		activated_light.show()
		deactivate_light.hide()
	else:
		activated_light.hide()
		deactivate_light.show()
	match switch_index:
		1:
			order = "first"
		2:
			order = "second"
		3:
			order = "third"
		4:
			order = "fourth"
		5:
			order = "fifth"
		6:
			order = "sixth"


func _on_interactable_on_interact():
	switch_active = !switch_active
	
	if switch_active:
		activated_light.show()
		deactivate_light.hide()
		animation_tree.switch_into_on_position()
		player_ui.display_gameplay_text("You activated the %s switch" %order, 2)
	else:
		activated_light.hide()
		deactivate_light.show()
		animation_tree.switch_into_off_position()
		player_ui.display_gameplay_text("You deactivated the %s switch" %order, 2)
	
	audio.play()
