extends Control
class_name TutorialPopUp


func _ready() -> void:
	hide()
	await get_tree().create_timer(4).timeout
	open_tutorial()

func open_tutorial() -> void:
	show()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	get_tree().paused = true


func close_tutorial() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false


func _on_continue_button_pressed() -> void:
	close_tutorial()
