extends Node
class_name PlayerAudioManager

@onready var player_voice: AudioStreamPlayer3D = $PlayerVoice
@onready var player_footsteps: AudioStreamPlayer3D = $PlayerFootsteps
@onready var walker_wheels: AudioStreamPlayer3D = $WalkerWheels
@onready var item: AudioStreamPlayer3D = $Item


func load_gun() -> void:
	pass


func shoot_gun() -> void:
	pass


func start_footsteps() -> void:
	player_footsteps.play()


func stop_footsteps() -> void:
	player_footsteps.stop()


func start_walker_wheels() -> void:
	walker_wheels.play()


func stop_walker_wheels() -> void:
	walker_wheels.stop()
