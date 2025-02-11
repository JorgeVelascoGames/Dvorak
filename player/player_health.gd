extends Node
class_name PlayerHealth

enum HEALTH_STATE {healthy, injure, dying}

signal new_heal_state(HEAL_STATE : HEALTH_STATE)

@export var health_state := HEALTH_STATE.healthy
@export var time_to_heal_up := 30.00
@export var time_to_recover_from_dying := 15.00

@export_category("In-game messages")
@export var full_health_messages : Array[String] = []
@export var damaged_messages : Array[String] = []
@export var dying_messages : Array[String] = []

@export var dying_overlay_textures : Array[Texture2D] = []

@onready var player : Player = owner as Player
@onready var damaged_heal_timer: Timer = $DamagedHealTimer
@onready var vhs_effect : VHSEffect = get_tree().get_first_node_in_group("vhs_effect")

var heal_tween : Tween
var injured_screen_overlay


func player_hit() -> void:
	if health_state == HEALTH_STATE.dying:
		player.player_die()
		return
	
	change_health_state(health_state + 1) 
	damaged_heal_timer.stop()
	#Dying state last less
	if health_state == HEALTH_STATE.injure:
		damaged_heal_timer.start(time_to_heal_up)
		player.player_ui.display_gameplay_text(damaged_messages.pick_random(), 5)
	else:
		damaged_heal_timer.start(time_to_recover_from_dying)
		player.player_ui.display_gameplay_text(dying_messages.pick_random(), 5)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		player_hit()


func heal_up() -> void:
	if health_state == HEALTH_STATE.healthy:
		return
	change_health_state(health_state - 1)
	if health_state == HEALTH_STATE.healthy:
		player.player_ui.display_gameplay_text(full_health_messages.pick_random(), 5) 
	damaged_heal_timer.stop()
	if health_state != HEALTH_STATE.healthy:
		damaged_heal_timer.start(time_to_heal_up)


func change_health_state(new_state : HEALTH_STATE) -> void:
	health_state = new_state
	new_heal_state.emit(new_state)


func _on_damaged_heal_timer_timeout() -> void:
	heal_up()
