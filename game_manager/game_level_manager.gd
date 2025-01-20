extends Node
class_name GameLevelManager

@export var level_one : PackedScene
@export var level_two : PackedScene
@export var level_three : PackedScene

@onready var save_screen: Control = $SaveScreen

var current_game_scene : Node
var current_level_index : int

func enter_game_level() -> void:
	#check for save file
	load_game_level()


func next_level() -> void:
	load_game_level(current_level_index + 1)


func load_game_level(level : int = 1) -> void:
	current_level_index = level
	
	if current_game_scene:
		current_game_scene.queue_free()
	match level:
		1:
			AppManager.game_manager.loading_screen.load_scene(level_one)
		2:
			AppManager.game_manager.loading_screen.load_scene(level_two)
		3:
			AppManager.game_manager.loading_screen.load_scene(level_three)


func back_to_main_menu() -> void:
	AppManager.game_manager.load_new_screen(AppManager.game_manager.APP_STATE.menu)


func _on_loading_screen_new_scene_loaded(scene: Node) -> void:
	add_child(scene)
	current_game_scene = scene
