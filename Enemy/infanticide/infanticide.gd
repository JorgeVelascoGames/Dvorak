extends Enemy
class_name InfanticideEnemy

@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var infanticide_audio: AudioStreamPlayer3D = $InfanticideAudio

var queue_audio_file : Array = [
	preload("res://assets/audio/crying_woman.wav")
]
var original_speed : float
var super_speed := 14.00
var vhs_tween : Tween
var audio_queu_played := false
var dying_quotes = [
	"A sin remains unconfessed: this is not the end of their torment… nor of your guilt",
	"Another life ends at your hands, but your conscience bleeds anew, unhealed by silent prayers",
	"The hush of their final breath echoes your own torment—no redemption lies in this violence",
	"They collapse before you, yet the weight of your sin only grows, demanding a confession you dare not utter",
	"They collapse at your feet, but absolution slips away: you sense you’ve not reached the end of your cruelty",
	"With their final breath, you discover a deeper cruelty still within you…"
]


func _ready() -> void:
	super()
	original_speed = speed


func _process(delta: float) -> void:
	super(delta)
	if current_target:
		var distance = global_position.distance_to(current_target.global_position)

		if distance > 20:
			speed = super_speed
		else:
			speed = original_speed
	
		if distance < 5 and not visible_on_screen_notifier_3d.is_on_screen():
			play_audio_queu()


func shot_infanticide_enemy() -> void:
	if vhs_tween:
		vhs_tween.kill()
	if not player.player_ui.player_vhs_effect.visible:#That makes sure that only one quote is shown at a time
		player.player_ui.display_gameplay_text(dying_quotes.pick_random(), 5)
	
	player.player_ui.player_vhs_effect.show()
	player.player_ui.player_vhs_effect.shader_mat.set_shader_parameter("crease_noise", 2.0)
	player.player_ui.player_vhs_effect.shader_mat.set_shader_parameter("tape_crease_smear", 2.0)
	player.player_ui.player_vhs_effect.shader_mat.set_shader_parameter("noise_intensity", 0.2)
	vhs_tween = get_tree().create_tween()
	vhs_tween.set_parallel()
	vhs_tween.tween_method(_close_vhs_effect, 2.0, 0.0, 2.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	vhs_tween.tween_method(_close_vhs_noise, 0.2, 0.0, 2.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_ELASTIC)
	await vhs_tween.finished
	vhs_tween = null
	player.player_ui.player_vhs_effect.hide()


func _close_vhs_effect(amount : float) -> void:
	player.player_ui.player_vhs_effect.shader_mat.set_shader_parameter("crease_noise", amount)
	player.player_ui.player_vhs_effect.shader_mat.set_shader_parameter("tape_crease_smear", amount)


func _close_vhs_noise(amount : float) -> void:
	player.player_ui.player_vhs_effect.shader_mat.set_shader_parameter("noise_intensity", amount)


func play_audio_queu() -> void:
	if audio_queu_played:
		return
	audio_queu_played = true
	infanticide_audio.stream = queue_audio_file.pick_random()
	infanticide_audio.play()
