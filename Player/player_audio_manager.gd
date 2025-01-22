extends Node
class_name PlayerAudioManager

@export var walk_footsteps_time : float
@export var walker_footsteps_time : float
@export var run_footsteps_time : float

@onready var player_voice: AudioStreamPlayer3D = $PlayerVoice
@onready var player_footsteps: AudioStreamPlayer3D = $PlayerFootsteps
@onready var walker_wheels: AudioStreamPlayer3D = $WalkerWheels
@onready var item: AudioStreamPlayer3D = $Item
@onready var foot_steps_timer: Timer = $FootStepsTimer

const CROWBAR_SWING = preload("res://assets/audio/player/crowbar_swing.wav")
const FOOT_STEP = preload("res://assets/audio/player/foot_step.wav")
const GUN_SHOT = preload("res://assets/audio/player/gun_shot.wav")
const PREP_GUN = preload("res://assets/audio/player/prep_gun.wav")
const RELOAD_GUN = preload("res://assets/audio/player/reload_gun.wav")
const GUN_TRIGGER = preload("res://assets/audio/player/gun_trigger.mp3")
const FLASHLIGHT_SWITCH = preload("res://assets/audio/player/flashlight_switch.wav")


func load_gun() -> void:
	pass


func shoot_gun() -> void:
	item.stream = GUN_SHOT
	item.play()


func prepare_gun() -> void:
	item.stream = PREP_GUN
	item.play()


func crowbar_swing() -> void:
	pass


func gun_out_of_bullets() -> void:
	item.stream = GUN_TRIGGER
	item.volume_db += 12.0
	item.play(0.40)
	await item.finished
	item.pitch_scale += randf_range(-0.1, 0.2)
	await item.finished
	item.volume_db = 0.0
	item.pitch_scale = 1

func cancel_item_sound() -> void:
	item.stop()


func start_footsteps(is_on_walker := true, running := false) -> void:
	var correct_footsteps = walker_footsteps_time
	if is_on_walker:
		correct_footsteps = walker_footsteps_time
	if not is_on_walker and running:
		correct_footsteps = run_footsteps_time
	foot_steps_timer.start(correct_footsteps)


func stop_footsteps() -> void:
	foot_steps_timer.stop()


func start_walker_wheels() -> void:
	walker_wheels.play()


func stop_walker_wheels() -> void:
	walker_wheels.stop()


func flashlight_switch() -> void:
	item.stream = FLASHLIGHT_SWITCH
	item.volume_db = 10.0
	item.play()
	await item.finished
	item.volume_db = 0.0


func _on_foot_steps_timer_timeout() -> void:
	player_footsteps.play()
