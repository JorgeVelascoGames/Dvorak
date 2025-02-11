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
@onready var state_machine: StateMachine = $"../StateMachine"
@onready var balance_clues: AudioStreamPlayer = $BalanceClues
@onready var heartbeat: AudioStreamPlayer = $Heartbeat
@onready var hearthbeat_tween : Tween = get_tree().create_tween()

const CROWBAR_SWING = preload("res://assets/audio/player/crowbar_swing.wav")
const FOOT_STEP = preload("res://assets/audio/player/foot_step.wav")
const GUN_SHOT = preload("res://assets/audio/player/gun_shot.wav")
const PREP_GUN = preload("res://assets/audio/player/prep_gun.wav")
const RELOAD_GUN = preload("res://assets/audio/player/reload_gun.wav")
const GUN_TRIGGER = preload("res://assets/audio/player/gun_trigger.mp3")
const FLASHLIGHT_SWITCH = preload("res://assets/audio/player/flashlight_switch.wav")

var gun_fire_no_bullets : Array = [
	preload("uid://hri8nosrsv4e"),
	preload("uid://bsu4usamya3hn"),
	preload("uid://bea8gigu3p2gn"),
	preload("uid://cr2u4kqvx3kk8"),
	preload("uid://x2iim7qlvpg7"),
	preload("uid://unsd0trqiei"),
	preload("uid://xthpi6pyfgx5")
]

var pick_gun : Array = [
	preload("uid://di7jhw2sp6a63"),
	preload("uid://djdff8alalnn6"),
	preload("uid://cp1ua7py3k6kj"),
	preload("uid://dxd65fnfbiolk"),
	preload("uid://d3cxobewjmigc"),
	preload("uid://br4vs2jybr6xw"),
	preload("uid://dt8uxbm6feg8p"),
]

var correct_footsteps_timer : float = 0.0
var moving := false


func _process(delta: float) -> void:
	check_correct_footsteps_timer()
	if state_machine.state.name == "Walker":
		if $"../StateMachine/Walker".movement != Walker.MOVEMENT_TYPE.idle:
			if not moving:
				start_footsteps()
			moving = true
			if not walker_wheels.is_playing():
				walker_wheels.play()
		else :
			moving = false
			walker_wheels.stop()
			foot_steps_timer.stop()


func load_gun() -> void:
	item.stream = RELOAD_GUN
	item.play()


func stop_load_gun() -> void:
	item.stop()


func shoot_gun() -> void:
	item.stream = GUN_SHOT
	item.play()


func prepare_gun() -> void:
	item.stream = PREP_GUN
	item.play()


func crowbar_swing() -> void:
	item.stream = CROWBAR_SWING
	item.pitch_scale = randf_range(0.8, 1.15)
	item.play()
	await item.finished
	item.pitch_scale = 1


func gun_out_of_bullets() -> void:
	item.stream = gun_fire_no_bullets.pick_random()
	item.volume_db += 12.0
	item.play(0.40)
	await item.finished
	item.volume_db = 0.0


func cancel_item_sound() -> void:
	item.stop()


func start_footsteps() -> void:
	foot_steps_timer.start(correct_footsteps_timer)


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


func check_correct_footsteps_timer() -> void:
	if state_machine.state.name == "Walker":
		correct_footsteps_timer = walker_footsteps_time
	elif  state_machine.state.name == "Walk" and $"../StateMachine/Walk".sprinting:
		correct_footsteps_timer = run_footsteps_time
	elif  state_machine.state.name == "Walk" and not $"../StateMachine/Walk".sprinting:
		correct_footsteps_timer = walker_footsteps_time


func play_balance_clue(pitch : float = 1.0) -> void:
	balance_clues.pitch_scale = pitch
	balance_clues.play()


func start_hearthbeat() -> void:
	if hearthbeat_tween.is_running():
		hearthbeat_tween.kill()
	heartbeat.volume_db = -33
	heartbeat.play()
	hearthbeat_tween = get_tree().create_tween()
	hearthbeat_tween.tween_property(heartbeat, "volume_db", 12, 3)


func stop_hearthbeat() -> void:
	if hearthbeat_tween.is_running():
		hearthbeat_tween.kill()
	hearthbeat_tween.kill()
	hearthbeat_tween = get_tree().create_tween()
	hearthbeat_tween.tween_property(heartbeat, "volume_db", -33, 7)
	await hearthbeat_tween.finished
	heartbeat.stop()


func _on_foot_steps_timer_timeout() -> void:
	player_footsteps.play()
	if moving:
		start_footsteps()


func _on_state_machine_transitioned(state_name: Variant) -> void:
	if state_name == "Walk":
		if not moving:
			start_footsteps()
		moving = true
	else:
		moving = false
		foot_steps_timer.stop()


func _on_balance_feedback_new_threshold_reached(threshold: int) -> void:
	if threshold == 3:
		start_hearthbeat()
		return
	
	if heartbeat.playing and threshold != 3:
		stop_hearthbeat()
