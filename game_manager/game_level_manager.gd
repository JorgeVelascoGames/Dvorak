extends Node
class_name GameLevelManager

@export var level_one : PackedScene
@export var level_two : PackedScene
@export var level_three : PackedScene

@onready var save_screen: Control = $SaveScreen
@onready var loading_screen: LoadingScreen = $LoadingScreen

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
	
	if level == 1:
		loading_screen.load_scene(level_one)
	if level == 2:
		loading_screen.load_scene(level_two)
	if level == 3:
		loading_screen.load_scene(level_three)


func back_to_main_menu() -> void:
	current_game_scene.queue_free()
	AppManager.game_manager.load_new_screen(AppManager.game_manager.APP_STATE.menu)


func _on_loading_screen_new_scene_loaded(scene: Node) -> void:
	add_child(scene)
	current_game_scene = scene
