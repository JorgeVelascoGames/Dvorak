extends Control
class_name TutorialPopUp

signal finished_tutorial

@export var tutorial_text : String
@export var tutorial_text_italic : String
@export var open_on_ready := false
@export var open_on_ready_dealy := 0.0
##Wait said amount of time once the tutorial has already been triggered to show
@export var delay_to_show := 0.0

@onready var main_text_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LabelMargincontainer/MainTextLabel
@onready var h_separator: HSeparator = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HSeparator
@onready var italic_text_label: Label = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LabelMargincontainer2/ItalicTextLabel
@onready var label_margincontainer_2: MarginContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/LabelMargincontainer2

var already_displayed := false


func _ready() -> void:
	hide()
	
	set_up_text()
	
	if open_on_ready:
		await get_tree().create_timer(open_on_ready_dealy).timeout
		open_tutorial()


func set_up_text() -> void:
	main_text_label.text = tutorial_text
	if tutorial_text_italic != "":
		h_separator.show()
		label_margincontainer_2.show()
		italic_text_label.text = tutorial_text_italic


func open_tutorial() -> void:
	if already_displayed:
		return
	
	already_displayed = true
	
	await get_tree().create_timer(delay_to_show).timeout
	reparent(AppManager.game_manager)
	show()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	AppManager.game_manager.current_level_manager.process_mode = Node.PROCESS_MODE_DISABLED


func close_tutorial() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	AppManager.game_manager.current_level_manager.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().process_frame
	finished_tutorial.emit()


func _on_continue_button_pressed() -> void:
	close_tutorial()


func _on_player_detector_body_entered(body: Node3D) -> void:
	if body is Player:
		open_tutorial()
