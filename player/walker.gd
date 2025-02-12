extends Node3D
class_name WalkerModel

signal WalkerInteracted

@export var walker_hint : Hint

@onready var free_walker_position = $FreeWalkerPosition
@onready var flashlight: SpotLight3D = %Flashlight
@onready var walker_model: MeshInstance3D = $WalkerModel
@onready var player : Player = owner
@onready var flashlight_model: MeshInstance3D = $FlaslightModel/Flashlight
@onready var gun_model: MeshInstance3D = $GunSelectorHitbox/GunModel/Gun
@onready var crowbar_model: MeshInstance3D = $CrowbarSelectorHitbox/Crowbar/crowbar
@onready var walker_rigid_body: StaticBody3D = $WalkerRigidBody
@onready var walker_grab_area: Area3D = $WalkerGrabArea


func _ready() -> void:
	await get_tree().create_timer(2).timeout
	print(walker_grab_area.get_overlapping_bodies())


func _process(delta: float) -> void:
	if walker_grab_area.get_overlapping_bodies().is_empty():
		player.player_ui.hide_constant_hint(walker_hint)
		return
	if walker_grab_area.get_overlapping_bodies()[0] is Player and player.states_with_interact.has(player.state_machine.state.name):
		player.player_ui.add_constant_hint(walker_hint)
	else:
		player.player_ui.hide_constant_hint(walker_hint)


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
	flashlight_model.show()
	flashlight.move_flashlight()
	player.current_weapon = player.WEAPON.gun
	player.player_audio_manager.pick_up_gun()


func pick_up_crowbar():
	crowbar_model.hide()
	gun_model.show()
	flashlight_model.show()
	flashlight.move_flashlight()
	player.current_weapon = player.WEAPON.crowbar


func pick_up_flashlight() -> void:
	crowbar_model.show()
	gun_model.show()
	flashlight_model.hide()
	player.current_weapon = player.WEAPON.flashlight
	player.player_audio_manager.pick_up_flashlight()


func drop_weapons():
	crowbar_model.show()
	gun_model.show()
	flashlight_model.show()
	flashlight.move_flashlight()
	player.current_weapon = player.WEAPON.none
	player.player_audio_manager.drop_item()


func try_pick_walker() -> void:
	for body in walker_grab_area.get_overlapping_bodies():
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
	if player.current_weapon != player.WEAPON.flashlight:
		pick_up_flashlight()
		player.pick_up_flashlight()
	else:
		drop_weapons()
