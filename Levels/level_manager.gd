extends Node3D
##This class goes on the root node of a level
class_name LevelManager

@onready var exit_gate : ExitGate = $ExitGate
@onready var navigation_region_3d : NavigationRegion3D= $NavigationRegion3D
@onready var map_randomizer: MapRandomizer = $MapRandomizer
@onready var black_screen: ColorRect = $LevelUI/BlackScreen


# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
	generate_rooms()


func generate_rooms() -> void:
	#Generate de rooms
	map_randomizer.randomize_map(exit_gate)
	await map_randomizer.finish_randomization
	#bake the navmesh
	navigation_region_3d.bake_navigation_mesh()
	await navigation_region_3d.bake_finished
	var tween := get_tree().create_tween()
	tween.tween_property(black_screen, "color", Color(0,0,0,0), 4.0)
