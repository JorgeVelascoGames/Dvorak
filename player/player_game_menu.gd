extends Control


func open() -> void:
	if visible:
		_on_resume_button_pressed()
		return
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	show()


func _on_resume_button_pressed() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	hide()


func _on_quit_button_pressed() -> void:
	AppManager.game_manager.game_level_manager.back_to_main_menu()
