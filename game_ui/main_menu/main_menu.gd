extends Node3D

@export var steam_url: String  ## La URL de la página de Steam
@onready var black_screen_animator: AnimationPlayer = $BlackScreenAnimator
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var credits: ColorRect = $MainMenuUI/Credits

const VHS_EJECTED = preload("res://assets/audio/ambient/vhs_ejected.mp3")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		if credits.visible:
			$MainMenuUI/Credits/CreditsAnimator.stop()
			credits.hide()


func _on_play_button_pressed() -> void:
	audio_stream_player.stop()
	audio_stream_player.stream = VHS_EJECTED
	audio_stream_player.play()
	black_screen_animator.play_backwards("fade")
	await get_tree().create_timer(4.2).timeout
	AppManager.game_manager.load_new_screen(GameManager.APP_STATE.game)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_steam_button_pressed() -> void:
	if steam_url != "":
		OS.shell_open(steam_url)


func _on_tutorial_pressed() -> void:
	audio_stream_player.stop()
	audio_stream_player.stream = VHS_EJECTED
	audio_stream_player.play()
	black_screen_animator.play_backwards("fade")
	await get_tree().create_timer(4.2).timeout
	AppManager.game_manager.game_level_manager.load_tutorial()


func _on_credits_button_pressed() -> void:
	credits.show()
	$MainMenuUI/Credits/CreditsAnimator.play("roll_credits")
