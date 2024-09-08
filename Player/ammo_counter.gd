extends Node
class_name AmmoCounter

@export var ammo_stored := 15
@export var max_ammo_loaded := 8
@onready var ammo_loaded := max_ammo_loaded
@onready var player_ui: PlayerUI = $"../../PlayerUI"


func pick_up_ammo(amount : int) -> void:
	ammo_stored += amount


func reload() -> void:
	var empty_slots := max_ammo_loaded - ammo_loaded
	var loaded_bullets : int
	if empty_slots == 0:
		return
	
	if empty_slots >= ammo_stored:
		loaded_bullets = ammo_stored
		ammo_loaded += loaded_bullets
		ammo_stored = 0
	else:
		loaded_bullets = empty_slots
		ammo_stored -= loaded_bullets
		ammo_loaded = max_ammo_loaded
	
	player_ui.display_gameplay_text("You loaded %d bullets" %loaded_bullets, 2)


func try_fire_shot() -> bool:
	if ammo_loaded > 0:
		ammo_loaded -= 1
		return true
	else:
		return false
