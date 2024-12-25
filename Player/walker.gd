extends Node3D
class_name WalkerModel

signal WalkerInteracted

@onready var free_walker_position = $FreeWalkerPosition
@onready var flashlight: SpotLight3D = $Flashlight
@onready var walker_model: MeshInstance3D = $WalkerModel
@onready var player : Player = owner
@onready var flashlight_model: MeshInstance3D = $FlaslightModel/Flashlight
@onready var gun_model: MeshInstance3D = $GunSelectorHitbox/GunModel/Gun
@onready var crowbar_model: MeshInstance3D = $CrowbarSelectorHitbox/Crowbar/crowbar
@onready var walker_rigid_body: StaticBody3D = $WalkerRigidBody
@onready var top_text: MarginContainer = $TopText
@onready var walker_grab_area: Area3D = $WalkerGrabArea


func flashlight_togle() -> void:
	flashlight.toggle_flashlight()


func free_walker() -> void:
	walker_rigid_body.collision_layer = 1
	walker_model.layers = 1
	flashlight_model.layers = 1
	gun_model.layers = 1
	crowbar_model.layers = 1
	walker_rigid_body.process_mode = Node.PROCESS_MODE_INHERIT
	top_level = true
	global_position = free_walker_position.global_position


func grab_walker() -> void:
	walker_model.layers = 2
	flashlight_model.layers = 2
	gun_model.layers = 2
	crowbar_model.layers = 2
	walker_rigid_body.process_mode = Node.PROCESS_MODE_DISABLED
	top_level = false
	position = Vector3.ZERO
	rotation = Vector3.ZERO
	drop_weapons()


func pick_up_gun():
	crowbar_model.show()
	gun_model.hide()
	player.current_weapon = player.WEAPON.gun


func pick_up_crowbar():
	crowbar_model.hide()
	gun_model.show()
	player.current_weapon = player.WEAPON.crowbar


func drop_weapons():
	crowbar_model.show()
	gun_model.show()
	player.current_weapon = player.WEAPON.none


func try_pick_walker() -> void:
	for body in $WalkerGrabArea.get_overlapping_bodies():
		if body is Player:
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
