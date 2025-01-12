extends Node
class_name Inventory

@onready var player_ui: PlayerUI = $"../../PlayerUI"

var batteries_amount := 0
var pills := 0


func pick_batteries(amount : int = 1) -> void:
	batteries_amount += amount
	if amount > 1:
		player_ui.display_gameplay_text("You found %d battery" %amount, 2)
	else:
		player_ui.display_gameplay_text("You found %d batteries" %amount, 2)


func use_battery() -> bool:
	if batteries_amount > 0:
		batteries_amount -= 1
		return true
	player_ui.display_gameplay_text("You don't have any batteries left", 2)
	return false


func pick_pills(amount : int = 1) -> void:
	pills += amount
	if amount > 1:
		player_ui.display_gameplay_text("You found %d pills" %amount, 2)
	else:
		player_ui.display_gameplay_text("You found %d pill" %amount, 2)


func use_pills() -> bool:
	if pills > 0:
		pills -= 1
		return true
	player_ui.display_gameplay_text("You don't have any pills left", 4)
	return false
