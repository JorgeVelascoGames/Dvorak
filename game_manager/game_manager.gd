extends Node
class_name GameManager

enum APP_STATE {lenguage, advert, menu, game}

@export var advert_scree: PackedScene
@export var lenguage_selecton_menu : PackedScene
@export var main_menu : PackedScene
@export var first_scene := APP_STATE.lenguage

@onready var loading_screen: LoadingScreen = $LoadingScreen

var current_app_state := APP_STATE.lenguage
var current_screen : Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_new_screen(first_scene)


func next_app_state() -> void:
	if current_app_state != APP_STATE.game:
		current_app_state += 1
		load_new_screen(current_app_state)


func load_new_screen(screen : APP_STATE) -> void:
	if current_screen:
		current_screen.queue_free()
	if screen == APP_STATE.lenguage:
		loading_screen.load_scene(lenguage_selecton_menu)
	if screen == APP_STATE.advert:
		var new_screen = advert_scree.instantiate()
		add_child(new_screen)
		current_screen = new_screen
	if screen == APP_STATE.menu:
		var new_screen = main_menu.instantiate()
		add_child(new_screen)
		current_screen = new_screen
	if screen == APP_STATE.game:
		var new_screen = lenguage_selecton_menu.instantiate()
		add_child(new_screen)
		current_screen = new_screen


func add_new_scene(scene):
	add_child(scene)
	current_screen = scene
