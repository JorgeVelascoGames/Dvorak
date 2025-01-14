extends Node3D

enum LOOT {bullets, bateries, pills, nothing}

@export var max_number_of_bullets := 5
@export var min_number_of_bullets := 1

@onready var interactable: Interactable = $StaticBody3D/Interactable
@onready var animations = $AnimationTree["parameters/playback"]
@onready var player : Player = get_tree().get_first_node_in_group("player")

var selected_loot : LOOT
var number_of_bullets : int


func _ready() -> void:
	select_loot()


func select_loot() -> void:
	randomize()
	var loot_array = [LOOT.bullets, LOOT.bateries, LOOT.pills, LOOT.nothing, LOOT.nothing] #!
	selected_loot = loot_array.pick_random()
	number_of_bullets = randi_range(min_number_of_bullets, max_number_of_bullets)


func _on_interactable_on_long_interact() -> void:
	interactable.queue_free()
	animations.travel("open")
	
	match selected_loot:
		LOOT.bullets:
			player.ammo_counter.pick_up_ammo(number_of_bullets)
		LOOT.bateries:
			player.inventory.pick_batteries()
		LOOT.pills:
			player.inventory.pick_pills()
		LOOT.nothing:
			player.player_ui.display_gameplay_text("It's empty...", 4)


func _on_interactable_on_stop_long_interaction() -> void:
	animations.travel("closed") #back to close animation


func _on_interactable_on_start_long_interaction() -> void:
	animations.travel("forcing") #Force animation
