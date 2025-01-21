extends Control


func game_over() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	AppManager.game_manager.load_new_screen(GameManager.APP_STATE.menu)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
