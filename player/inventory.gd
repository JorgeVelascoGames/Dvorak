extends Node
class_name Inventory

@onready var player_ui: PlayerUI = $"../../PlayerUI"

@export var ammo_stored := 15
@export var batteries_amount := 0
@export var pills := 0

var lost_item_messages : Array[String] = [
	"As you hit the ground, %d %s scattered into the darkness…",
	"Your trembling hands fail you. %d %s slip away, beyond reach",
	"A brutal impact claims %d %s, left behind on the cold floor",
	"In your fall, %d %s tumble from your grasp, lost among the shadows",
	"The impact rattles your senses; %d %s spill out like fragments of hope",
	"The ground devours %d %s the moment you collapse",
	"A harsh jolt scatters %d %s around you, echoing your own disorientation"
]


func pick_batteries(amount : int = 1) -> void:
	batteries_amount += amount
	if amount == 1:
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


func lose_item_random() -> void:
	var item_types = ["bullet", "pill", "battery"]
	if ammo_stored <= 0:
		item_types.erase("bullet")
	if batteries_amount <= 0:
		item_types.erase("battery")
	if pills <= 0:
		item_types.erase("pill")
	
	if item_types.is_empty():
		return
	
	var selected_item_type = item_types.pick_random()
	print(selected_item_type)
	match selected_item_type:
		"bullet":
			lose_bullets()
		"pill":
			lose_pills()
		"battery":
			lose_batteries()


func lose_bullets() -> void:
	var temp := ammo_stored / 2
	var ammo_to_lose = randi_range(1, temp)
	ammo_to_lose = clampi(ammo_to_lose, 1, ammo_stored)
	ammo_stored -= ammo_to_lose
	player_ui.display_gameplay_text(lost_item_messages.pick_random() %[ammo_to_lose, "bullets"], 6)


func lose_pills() -> void:
	var pills_to_lose = randi_range(1, 3)
	pills_to_lose = clampi(pills_to_lose, 1, pills)
	pills -= pills_to_lose
	player_ui.display_gameplay_text(lost_item_messages.pick_random() %[pills_to_lose, "pills"], 6)


func lose_batteries() -> void:
	var batteries_to_lose = randi_range(1, 3)
	batteries_to_lose = clampi(batteries_to_lose, 1, batteries_amount)
	batteries_amount -= batteries_to_lose
	player_ui.display_gameplay_text(lost_item_messages.pick_random() %[batteries_to_lose, "batteries"], 6)
