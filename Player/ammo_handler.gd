extends Node
class_name AmmoHandler

@export var max_carried_ammo := 5
@export var initial_ammo_storage := 12

@onready var ammo_storage := initial_ammo_storage
@onready var current_carried_ammo = max_carried_ammo


func try_use_ammo() -> bool:
	if current_carried_ammo > 0:
		use_ammo()
		return true
	return false


func use_ammo() -> void:
	current_carried_ammo -= 1


func reload() -> void:
	var necessary_bullets = max_carried_ammo - current_carried_ammo
	if ammo_storage >= necessary_bullets:
		ammo_storage -= necessary_bullets
		current_carried_ammo = max_carried_ammo
	else:
		current_carried_ammo += ammo_storage
		ammo_storage = 0


func pick_up_ammo(ammount: int) -> void:
	ammo_storage += ammount


#func update_ammo_label() -> void:
	#ammo_label.text = str(ammo_storage[weapon_handler.current_active_weapon.ammo_type]) 
