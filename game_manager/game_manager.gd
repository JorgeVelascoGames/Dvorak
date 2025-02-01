extends Node
class_name GameManager

enum APP_STATE {lenguage, advert, menu, game, tutorial}

signal on_calamity

@export var lenguage_selecton_menu : PackedScene
@export var advert_scree: PackedScene
@export var main_menu : PackedScene
@export var tutorial : PackedScene
@export var first_scene := APP_STATE.lenguage

@onready var loading_screen: LoadingScreen = $LoadingScreen
@onready var game_level_manager: GameLevelManager = $GameLevelManager
@onready var enemy_manager: EnemyManager = $EnemyManager

var current_app_state := APP_STATE.lenguage
var current_screen : Node
var current_level_manager : LevelManager


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AppManager.game_manager = self
	load_new_screen(first_scene)


func load_new_screen(screen : APP_STATE) -> void:
	current_app_state = screen
	if current_screen:
		current_screen.queue_free()
	if screen == APP_STATE.lenguage:
		loading_screen.load_scene(lenguage_selecton_menu)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if screen == APP_STATE.advert:
		loading_screen.load_scene(advert_scree)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if screen == APP_STATE.menu:
		loading_screen.load_scene(main_menu)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if screen == APP_STATE.game:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		game_level_manager.enter_game_level()
	if screen == APP_STATE.tutorial:
		loading_screen.load_scene(tutorial)
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_loading_screen_new_scene_loaded(scene: Node) -> void:
	#add_child(scene)
	current_screen = scene
