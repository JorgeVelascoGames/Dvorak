extends Node3D

@export var steam_url: String  ## La URL de la página de Steam


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	AppManager.game_manager.load_new_screen(GameManager.APP_STATE.game)


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_steam_button_pressed() -> void:
	if steam_url != "":
		OS.shell_open(steam_url)


func _on_tutorial_pressed() -> void:
	AppManager.game_manager.game_level_manager.load_tutorial()
