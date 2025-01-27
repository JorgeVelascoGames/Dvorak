extends Control
class_name TutorialPopUp

@export var open_on_ready := false
@export var open_on_ready_dealy := 0.0
##Wait said amount of time once the tutorial has already been triggered to show
@export var delay_to_show := 0.0

var already_displayed := false

func _ready() -> void:
	hide()
	
	if open_on_ready:
		await get_tree().create_timer(open_on_ready_dealy).timeout
		open_tutorial()

func open_tutorial() -> void:
	if already_displayed:
		return
	
	already_displayed = true
	
	await get_tree().create_timer(delay_to_show).timeout
	show()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	get_tree().paused = true


func close_tutorial() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false


func _on_continue_button_pressed() -> void:
	close_tutorial()


func _on_player_detector_body_entered(body: Node3D) -> void:
	if body is Player:
		open_tutorial()
