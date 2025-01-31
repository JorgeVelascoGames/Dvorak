extends Node
class_name AmmoCounter

@export var ammo_stored := 15
@export var max_ammo_loaded := 8
@export var reload_hint : Hint 

@onready var ammo_loaded := max_ammo_loaded
@onready var player_ui: PlayerUI = $"../../PlayerUI"
@onready var player: Player = $"../.."


func _process(delta: float) -> void:
	if player.current_weapon != player.WEAPON.gun:
		player_ui.hide_constant_hint(reload_hint)


func pick_up_ammo(amount : int) -> void:
	ammo_stored += amount
	player_ui.display_gameplay_text("You found %d bullets" %amount, 2)


func reload() -> void:
	if ammo_stored <= 0:
		player_ui.display_gameplay_text("You don't have any bullet left", 2)
		return
	
	var empty_slots := max_ammo_loaded - ammo_loaded
	var loaded_bullets : int
	if empty_slots == 0:
		player_ui.display_gameplay_text("The magazine is already full", 2)
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
	player_ui.hide_constant_hint(reload_hint)


func try_fire_shot() -> bool:
	if ammo_loaded > 0:
		ammo_loaded -= 1
		return true
	else:
		player_ui.add_constant_hint(reload_hint)
		return false
