extends Node
class_name GameManager

enum APP_STATE {lenguage, advert, menu, game}

@export var lenguage_selecton_menu : PackedScene
@export var advert_scree: PackedScene
@export var main_menu : PackedScene
@export var game : PackedScene
@export var first_scene := APP_STATE.lenguage

@onready var loading_screen: LoadingScreen = $LoadingScreen

var current_app_state := APP_STATE.lenguage
var current_screen : Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AppManager.game_manager = self
	load_new_screen(first_scene)


func next_app_state() -> void:
	if current_app_state != APP_STATE.game:
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
		loading_screen.load_scene(game)


func add_new_scene(scene):
	add_child(scene)
	current_screen = scene
