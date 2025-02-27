extends LevelManager

@export var steam_url: String  ## La URL de la página de Steam

@onready var tutorial_pop_up: Control = $TutorialPopUp


func _ready() -> void:
	AppManager.game_manager.current_level_manager = self
	return
	await get_tree().create_timer(15).timeout
	tutorial_pop_up.show()
	reparent(AppManager.game_manager)
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	AppManager.game_manager.current_level_manager.process_mode = Node.PROCESS_MODE_DISABLED


func _on_whislist_button_pressed() -> void:
	if steam_url != "":
		OS.shell_open(steam_url)
	AppManager.game_manager.game_level_manager.back_to_main_menu()
	queue_free()


func _on_exit_button_pressed() -> void:
	AppManager.game_manager.game_level_manager.back_to_main_menu()
	queue_free()
