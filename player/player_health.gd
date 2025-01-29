extends Node
class_name PlayerHealth

enum HEALTH_STATE {healthy, injure, dying}
@export var health_state := HEALTH_STATE.healthy
@export var time_to_heal_up := 30.0
@export var time_to_recover_from_dying := 20.0

@onready var player : Player = owner as Player
@onready var damaged_heal_timer: Timer = $DamagedHealTimer

var heal_tween : Tween


func player_hit() -> void:
	if health_state == HEALTH_STATE.dying:
		player.player_die()
		return
	
	health_state += 1
	damaged_heal_timer.stop()
	#Dying state last less
	if health_state == HEALTH_STATE.injure:
		damaged_heal_timer.start(time_to_heal_up)
	else:
		damaged_heal_timer.start(time_to_recover_from_dying)
	#damaged_overlay.show()#TODO
	#heal_tween = get_tree().create_tween()
	#heal_tween.tween_property(damaged_overlay, "color", Color(0,0,0,0), time_to_heal_up)


func heal_up() -> void:
	if health_state == HEALTH_STATE.healthy:
		return
	health_state -= 1
	damaged_heal_timer.stop()
	if health_state != HEALTH_STATE.healthy:
		damaged_heal_timer.start(time_to_heal_up)
	#heal_tween.kill() #TODO
	#heal_tween = get_tree().create_tween()
	#heal_tween.tween_property(damaged_overlay, "color", Color(0,0,0,0), 2.0)
	#await heal_tween.finished
	#damaged_overlay.hide()
	#damaged_overlay.color = damage_texture_original_color
