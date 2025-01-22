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


func load_gun() -> void:
	pass


func shoot_gun() -> void:
	pass

func crowbar_swing() -> void:
	pass


func gun_out_of_bullets() -> void:
	pass


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


func _on_foot_steps_timer_timeout() -> void:
	player_footsteps.play()
