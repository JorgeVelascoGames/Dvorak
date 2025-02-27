extends Node3D

signal finished_looting

enum LOOT {bullets, bateries, pills, nothing}

@export var max_loot_amount := 5
@export var min_loot_amount := 1
@export var fixed_drop_type := LOOT.nothing

@onready var interactable: Interactable = $StaticBody3D/Interactable
@onready var animations = $AnimationTree["parameters/playback"]
@onready var player : Player = get_tree().get_first_node_in_group("player")
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

var selected_loot : LOOT
var loot_amount : int
var empty_messages = [
	"It's empty...",
	"You find only dust… as silent as your unspoken prayers",
	"Emptiness greets you like a whispered condemnation",
	"Your hope slips away into the void, leaving you with nothing",
	"All that lingers here is dust, clinging to the last shred of hope you carried"
]
const DRAWER_OPEN = preload("res://assets/audio/drawer_open.wav")


func _ready() -> void:
	select_loot()


func select_loot() -> void:
	loot_amount = randi_range(min_loot_amount, max_loot_amount)
	if fixed_drop_type != LOOT.nothing:
		selected_loot = fixed_drop_type
		return
	randomize()
	var loot_array = [LOOT.bullets, LOOT.bateries, LOOT.pills, LOOT.nothing, LOOT.nothing] #!
	selected_loot = loot_array.pick_random()


func _on_interactable_on_long_interact() -> void:
	interactable.queue_free()
	animations.travel("open")
	audio_stream_player_3d.stop()
	audio_stream_player_3d.stream = DRAWER_OPEN
	audio_stream_player_3d.volume_db = 22
	audio_stream_player_3d.play()
	
	match selected_loot:
		LOOT.bullets:
			player.ammo_counter.pick_up_ammo(loot_amount)
		LOOT.bateries:
			player.inventory.pick_batteries(loot_amount)
		LOOT.pills:
			player.inventory.pick_pills(loot_amount)
		LOOT.nothing:
			randomize()
			player.player_ui.display_gameplay_text(empty_messages.pick_random(), 4)
	
	finished_looting.emit()

func _on_interactable_on_stop_long_interaction() -> void:
	animations.travel("closed") #back to close animation
	audio_stream_player_3d.stop()


func _on_interactable_on_start_long_interaction() -> void:
	animations.travel("forcing") #Force animation
	audio_stream_player_3d.play()
