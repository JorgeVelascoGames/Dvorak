extends Node3D
class_name WalkerModel

signal WalkerInteracted

@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var free_walker_position = $FreeWalkerPosition
@onready var flashlight: SpotLight3D = $Flashlight
@onready var walker_model: MeshInstance3D = $WalkerModel
@onready var crowbar: Node3D = $CrowbarSelectorHitbox/Crowbar
@onready var gun_model: Node3D = $GunSelectorHitbox/GunModel
@onready var player : Player = owner


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
	drop_weapons()


func pick_up_gun():
	crowbar.show()
	gun_model.hide()
	player.current_weapon = player.WEAPON.gun


func pick_up_crowbar():
	crowbar.hide()
	gun_model.show()
	player.current_weapon = player.WEAPON.crowbar


func drop_weapons():
	crowbar.show()
	gun_model.show()
	player.current_weapon = player.WEAPON.none


func _on_interactable_on_interact() -> void:
	WalkerInteracted.emit()


func _on_gun_interact_on_interact() -> void:
	if player.current_weapon != player.WEAPON.gun:
		pick_up_gun()
	else:
		drop_weapons()


func _on_crowbar_interact_on_interact() -> void:
	if player.current_weapon != player.WEAPON.crowbar:
		pick_up_crowbar()
	else:
		drop_weapons()


func _on_flashlight_interact_on_interact() -> void:
	flashlight_togle()
