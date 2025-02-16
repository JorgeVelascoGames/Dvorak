extends Node
class_name EnemyAudioManager

@export var time_between_steps := 0.9

@onready var constant_audio: AudioStreamPlayer3D = $EnemyConstantAudio
@onready var damage_audio: AudioStreamPlayer3D = $EnemyDamageAudio
@onready var dead_audio: AudioStreamPlayer3D = $EnemyDeadAudio
@onready var spawn_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var steps_sound: AudioStreamPlayer3D = $EnemyStepsSound
@onready var vfx: AudioStreamPlayer3D = $EnemyVFX
@onready var steps_volume := steps_sound.volume_db


func _ready() -> void:
	pass
	#constant_audio.play()
	#spawn_sound.play()


func _process(delta: float) -> void:
	if owner.can_move and owner.provoke:
		steps_sound.stream_paused = false
	else:
		steps_sound.stream_paused = true


func play_dead_audio(stop_constant_sound : bool = true) -> Signal:
	if stop_constant_sound:
		constant_audio.stop()
	#dead_audio.play()
	return dead_audio.finished


func play_sfx() -> Signal:
	#vfx.play()
	return vfx.finished


func _on_steps_timer_timeout() -> void:
	steps_sound.play()
