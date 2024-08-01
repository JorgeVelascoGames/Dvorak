extends Node3D

var book_spawn_points :Array[Marker3D] = []
@onready var exit_gate = $ExitGate
@onready var navigation_region_3d = $NavigationRegion3D
@onready var room_randomizer = $NavigationRegion3D/Rooms/RoomRandomizer


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_rooms()


func generate_rooms() -> void:
	#Generate de rooms
	room_randomizer.randomize_rooms()
	await room_randomizer.RoomsRandomized
	#bake the navmesh
	navigation_region_3d.bake_navigation_mesh()
	await navigation_region_3d.bake_finished
	#Distribute books
	distribute_books()
	#Close loading screen


func distribute_books() -> void:
	var markers : Array[Node] = get_tree().get_nodes_in_group("book_markers")
	for marker in markers:
		if marker is Marker3D:
			book_spawn_points.append(marker)
	
	exit_gate.distribute_books(book_spawn_points)
