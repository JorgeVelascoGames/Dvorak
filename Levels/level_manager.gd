extends Node3D
##This class goes on the root node of a level
class_name LevelManager

signal finish_current_level

@export var enemy_container : Node3D

@onready var exit_gate : ExitGate = %ExitGate
@onready var navigation_region_3d : NavigationRegion3D= $NavigationRegion3D
@onready var map_randomizer: MapRandomizer = %MapRandomizer
@onready var black_screen: ColorRect = $LevelUI/BlackScreen
@onready var white_screen: ColorRect = $LevelUI/WhiteScreen


# Called when the node enters the scene tree for the first time.
func _ready():
	AppManager.game_manager.current_level_manager = self
	generate_rooms()


func generate_rooms() -> void:
	#Generate de rooms
	map_randomizer.randomize_map(exit_gate)
	await map_randomizer.finish_randomization
	await get_tree().create_timer(0.5) #To make sure it wors
	#bake the navmesh
	navigation_region_3d.bake_navigation_mesh()
	await navigation_region_3d.bake_finished
	var tween := get_tree().create_tween()
	tween.tween_property(black_screen, "color", Color(0,0,0,0), 4.0)


func finish_level() -> void:
	finish_current_level.emit()
	var tween := get_tree().create_tween()
	tween.tween_property(white_screen, "color", Color.WHITE, 4.0)
	await tween.finished
	AppManager.game_manager.game_level_manager.back_to_main_menu()


func lost_level() -> void:
	finish_current_level.emit()
