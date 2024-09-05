extends Node
class_name EnemyAudioManager

@onready var constant_audio: AudioStreamPlayer3D = $EnemyConstantAudio
@onready var damage_audio: AudioStreamPlayer3D = $EnemyDamageAudio
@onready var dead_audio: AudioStreamPlayer3D = $EnemyDeadAudio
@onready var spawn_sound: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var steps_sound: AudioStreamPlayer3D = $EnemyStepsSound
@onready var vfx: AudioStreamPlayer3D = $EnemyVFX


func _ready() -> void:
	constant_audio.play()
	spawn_sound.play()


func play_dead_audio(stop_constant_sound : bool = true) -> Signal:
	if stop_constant_sound:
		constant_audio.stop()
	dead_audio.play()
	return dead_audio.finished


func play_random_step_sound() -> void:
	steps_sound.play()


func play_sfx() -> Signal:
	vfx.play()
	return vfx.finished
