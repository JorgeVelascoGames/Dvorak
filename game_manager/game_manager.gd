extends Node
class_name GameManager

enum APP_STATE {lenguage, advert, menu, game}

@export var lenguage_selecton_menu : PackedScene
@export var advert_scree: PackedScene
@export var main_menu : PackedScene
@export var first_scene := APP_STATE.lenguage

@onready var loading_screen: LoadingScreen = $LoadingScreen
@onready var game_level_manager: GameLevelManager = $GameLevelManager
@onready var enemy_manager: EnemyManager = $EnemyManager

var current_app_state := APP_STATE.lenguage
var current_screen : Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AppManager.game_manager = self
	load_new_screen(first_scene)


func next_app_state() -> void:
	if current_app_state != APP_STATE.game:
		@warning_ignore("int_as_enum_without_cast")
		current_app_state += 1
		load_new_screen(current_app_state)


func load_new_screen(screen : APP_STATE) -> void:
	current_app_state = screen
	if current_screen:
		current_screen.queue_free()
	if screen == APP_STATE.lenguage:
		loading_screen.load_scene(lenguage_selecton_menu)
	if screen == APP_STATE.advert:
		loading_screen.load_scene(advert_scree)
	if screen == APP_STATE.menu:
		loading_screen.load_scene(main_menu)
	if screen == APP_STATE.game:
		current_screen.queue_free()
		game_level_manager.enter_game_level()


func _on_loading_screen_new_scene_loaded(scene: Node) -> void:
	add_child(scene)
	current_screen = scene
