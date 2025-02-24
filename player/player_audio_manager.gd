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
@onready var hit_flesh_audio: AudioStreamPlayer = $HitFlesh

const CROWBAR_SWING = preload("res://assets/audio/player/crowbar_swing.wav")
const FOOT_STEP = preload("res://assets/audio/player/foot_step.wav")
const GUN_SHOT = preload("res://assets/audio/player/gun_shot.wav")
const PREP_GUN = preload("res://assets/audio/player/prep_gun.wav")
const RELOAD_GUN = preload("res://assets/audio/player/reload_gun.wav")
const GUN_TRIGGER = preload("res://assets/audio/player/gun_trigger.mp3")
const FLASHLIGHT_SWITCH = preload("res://assets/audio/player/flashlight_switch.wav")
const PIC_UP_CROWBAR = preload("res://assets/audio/pic_up_crowbar.wav")
const PILLS_SHAKING = preload("res://assets/audio/player/pills_shaking.wav")
const EMTPY_PILLS = preload("res://assets/audio/player/emtpy_pills.wav")
const SWALLOW_PILLS = preload("res://assets/audio/player/swallow_pills.wav")

var gun_fire_no_bullets : Array = [
	preload("res://assets/audio/player/gun_fire_no_bullets/gun fired no bullets 1.wav"),
	preload("res://assets/audio/player/gun_fire_no_bullets/gun fired no bullets 2.wav"),
	preload("res://assets/audio/player/gun_fire_no_bullets/gun fired no bullets 3.wav"),
	preload("res://assets/audio/player/gun_fire_no_bullets/gun fired no bullets 4.wav"),
	preload("res://assets/audio/player/gun_fire_no_bullets/gun fired no bullets 5.wav"),
	preload("res://assets/audio/player/gun_fire_no_bullets/gun fired no bullets 6.wav"),
	preload("res://assets/audio/player/gun_fire_no_bullets/gun fired no bullets 7.wav")
]

var pick_gun : Array = [
	preload("res://assets/audio/player/pick_gun/dagger sheath 1.wav"),
	preload("res://assets/audio/player/pick_gun/dagger sheath 2.wav"),
	preload("res://assets/audio/player/pick_gun/dagger sheath 3.wav"),
	preload("res://assets/audio/player/pick_gun/dagger sheath 4.wav"),
	preload("res://assets/audio/player/pick_gun/dagger sheath 5.wav"),
	preload("res://assets/audio/player/pick_gun/dagger sheath 6.wav"),
	preload("res://assets/audio/player/pick_gun/dagger sheath 7.wav"),
]

var pick_flashlight : Array = [
	preload("res://assets/audio/player/pick_flashlight_vfx/bounce on 1.wav"),
	preload("res://assets/audio/player/pick_flashlight_vfx/bounce on 2.wav"),
	preload("res://assets/audio/player/pick_flashlight_vfx/bounce on 3.wav"),
	preload("res://assets/audio/player/pick_flashlight_vfx/bounce on 4.wav"),
	preload("res://assets/audio/player/pick_flashlight_vfx/bounce on 5.wav"),
	preload("res://assets/audio/player/pick_flashlight_vfx/bounce on 6.wav"),
	preload("res://assets/audio/player/pick_flashlight_vfx/bounce on 7.wav"),
	preload("res://assets/audio/player/pick_flashlight_vfx/bounce on 8.wav"),
]
var drop_item_sfx : Array = [
	preload("res://assets/audio/drop_item/umbrella close 1.wav"),
	preload("res://assets/audio/drop_item/umbrella close 2.wav"),
	preload("res://assets/audio/drop_item/umbrella close 3.wav"),
	preload("res://assets/audio/drop_item/umbrella close 4.wav"),
	preload("res://assets/audio/drop_item/umbrella close 5.wav"),
	preload("res://assets/audio/drop_item/umbrella close 6.wav"),
	preload("res://assets/audio/drop_item/umbrella close 7.wav"),
]
var finish_load_gun_sfx : Array = [
	preload("res://assets/audio/gun_cocking/gun cocking 1.wav"),
	preload("res://assets/audio/gun_cocking/gun cocking 2.wav"),
	preload("res://assets/audio/gun_cocking/gun cocking 3.wav"),
	preload("res://assets/audio/gun_cocking/gun cocking 4.wav"),
	preload("res://assets/audio/gun_cocking/gun cocking 5.wav"),
]
var changing_batteries_sfx : Array = [
	preload("res://assets/audio/batery_change/changing_batteries/antenna contract 1.wav"),
	preload("res://assets/audio/batery_change/changing_batteries/antenna contract 2.wav"),
	preload("res://assets/audio/batery_change/changing_batteries/antenna contract 4.wav"),
	preload("res://assets/audio/batery_change/changing_batteries/antenna contract 5.wav"),
	preload("res://assets/audio/batery_change/changing_batteries/antenna contract 6.wav"),
	preload("res://assets/audio/batery_change/changing_batteries/antenna contract 7.wav"),
]
var finish_change_batteries_sfx : Array = [
	preload("res://assets/audio/batery_change/stapler 1.wav"),
	preload("res://assets/audio/batery_change/stapler 2.wav"),
	preload("res://assets/audio/batery_change/stapler 3.wav"),
	preload("res://assets/audio/batery_change/stapler 4.wav"),
	preload("res://assets/audio/batery_change/stapler 5.wav"),
	preload("res://assets/audio/batery_change/stapler 6.wav"),
	preload("res://assets/audio/batery_change/stapler 7.wav"),
]

var correct_footsteps_timer : float = 0.0
var moving := false

@export var volume_dictionary = {
	CROWBAR_SWING : 1,
	GUN_SHOT : 1,
	PREP_GUN : 1,
	RELOAD_GUN : 1,
	GUN_TRIGGER : 1,
	FLASHLIGHT_SWITCH : 1,
	PIC_UP_CROWBAR : 12,
	PILLS_SHAKING : 1,
	EMTPY_PILLS : 12,
	SWALLOW_PILLS : 10,
	"gun_fire_no_bullets" : 12,
	"pick_gun" : 1,
	"pick_flashlight" : 12,
	"drop_item_sfx" : 12,
	"finish_load_gun_sfx" : 1,
	"changing_batteries_sfx" : 12,
	"finish_change_batteries_sfx" : 12
}


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


#region Gun
func load_gun() -> void:
	item.stream = RELOAD_GUN
	item.volume_db = volume_dictionary[RELOAD_GUN]
	item.play()


func finish_load_gun() -> void:
	item.stream = finish_load_gun_sfx.pick_random()
	item.volume_db = volume_dictionary["finish_load_gun_sfx"]
	item.play()


func stop_load_gun() -> void:
	item.stop()


func shoot_gun() -> void:
	item.stream = GUN_SHOT
	item.volume_db = volume_dictionary[GUN_SHOT]
	item.play()


func prepare_gun() -> void:
	item.stream = PREP_GUN
	item.volume_db = volume_dictionary[PREP_GUN]
	item.play()


func pick_up_gun() -> void:
	item.stream = pick_gun.pick_random()
	item.volume_db = volume_dictionary["pick_gun"]
	item.play()


func gun_out_of_bullets() -> void:
	item.stream = gun_fire_no_bullets.pick_random()
	item.volume_db = volume_dictionary["gun_fire_no_bullets"]
	item.play(0.40)
#endregion


#region Crowbar
func crowbar_swing() -> void:
	item.stream = CROWBAR_SWING
	item.volume_db = volume_dictionary[CROWBAR_SWING]
	item.pitch_scale = randf_range(0.8, 1.15)
	item.play()
	await get_tree().create_timer(1.88) #We use this instead of the audio stream signal in case the sound is interrupted
	item.pitch_scale = 1


func pick_up_crowbar() -> void:
	item.stream = PIC_UP_CROWBAR
	item.volume_db = volume_dictionary[PIC_UP_CROWBAR]
	item.play()
#endregion


func cancel_item_sound() -> void:
	item.stop()


#region Player movement
func start_footsteps() -> void:
	foot_steps_timer.start(correct_footsteps_timer)


func stop_footsteps() -> void:
	foot_steps_timer.stop()


func start_walker_wheels() -> void:
	walker_wheels.play()


func stop_walker_wheels() -> void:
	walker_wheels.stop()
	item.volume_db = 0.0


func check_correct_footsteps_timer() -> void:
	if state_machine.state.name == "Walker":
		correct_footsteps_timer = walker_footsteps_time
	elif  state_machine.state.name == "Walk" and $"../StateMachine/Walk".sprinting:
		correct_footsteps_timer = run_footsteps_time
	elif  state_machine.state.name == "Walk" and not $"../StateMachine/Walk".sprinting:
		correct_footsteps_timer = walker_footsteps_time
#endregion


#region Flashlight
func flashlight_switch() -> void:
	item.stream = FLASHLIGHT_SWITCH
	item.volume_db = volume_dictionary[FLASHLIGHT_SWITCH]
	item.play()


func pick_up_flashlight() -> void:
	item.stream = pick_flashlight.pick_random()
	item.volume_db = volume_dictionary["pick_flashlight"]
	item.play()
	await item.finished


func changing_batteries() -> void:
	item.stream = changing_batteries_sfx.pick_random()
	item.volume_db = volume_dictionary["changing_batteries_sfx"]
	item.play()


func finish_change_batteries() -> void:
	item.stream = finish_change_batteries_sfx.pick_random()
	item.volume_db = volume_dictionary["finish_change_batteries_sfx"]
	item.play()
#endregion


#region Pills
func opening_pills() -> void:
	item.stream = PILLS_SHAKING
	item.volume_db = volume_dictionary[PILLS_SHAKING]
	item.play()


func swallow_pills() -> void:
	item.stream = SWALLOW_PILLS
	item.volume_db = volume_dictionary[SWALLOW_PILLS]
	item.play()


func no_pills() -> void:
	item.stream = EMTPY_PILLS
	item.volume_db = volume_dictionary[EMTPY_PILLS]
	item.play()
#endregion


func drop_item() -> void:
	item.stream = drop_item_sfx.pick_random()
	item.volume_db = volume_dictionary["drop_item_sfx"]
	item.play()


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


func hit_flesh() -> void:
	hit_flesh_audio.play()


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
