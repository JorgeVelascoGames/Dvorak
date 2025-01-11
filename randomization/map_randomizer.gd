extends Node3D
class_name MapRandomizer

signal finish_randomization

@export var rooms_array : Array[Marker3D]
@export var closed_room_door : PackedScene
@export var closed_rooms : int = 0
@export var rooms_father : Node3D
@export var min_items_to_spawn : int
@export var max_items_to_spawn : int
@export var items_father : Node3D
@export var rooms : Array[PackedScene]
@export var randomizer_container : Node3D

var items : Array[PackedScene]
var instantiated_rooms : Array[Room]


func _ready() -> void:
	if not rooms_father:
		rooms_father = self
	if not items_father:
		items_father = self
	if not randomizer_container:
		randomizer_container = self

func randomize_map(exit_gate : ExitGate) -> void:
	spawn_rooms()
	await get_tree().process_frame
	spawn_items()
	await get_tree().process_frame
	hide_cross()
	await  get_tree().process_frame
	spawn_books(exit_gate)
	await  get_tree().process_frame
	activate_randomizers()
	await get_tree().process_frame
	finish_randomization.emit()


func spawn_rooms() -> void:
	rooms_array.shuffle()
	
	if closed_rooms > 0 and closed_rooms < rooms_array.size():
		for i in closed_rooms:
			var new_door : Node3D = closed_room_door.instantiate()
			rooms_father.add_child(new_door)
			var position := rooms_array.pop_back() as Node3D
			new_door.position = position.position #We let unused rooms closed
			new_door.rotation = position.rotation
	
	rooms.shuffle()
	
	for room_position in rooms_array:
		var new_room = rooms.pop_back().instantiate() as Room
		rooms_father.add_child(new_room)
		new_room.position = room_position.position
		new_room.rotation = room_position.rotation
		instantiated_rooms.append(new_room)


func spawn_books(exit_gate : ExitGate)-> void:
	if not exit_gate.are_books_ready:
		await  exit_gate.pass_and_books_ready
	
	var books_spawn_points : Array[Marker3D]
	for room in instantiated_rooms:
		books_spawn_points.append(room.atril_spawn_point)
	exit_gate.distribute_books(books_spawn_points)


func spawn_items() -> void:
	var number_of_items = randi_range(min_items_to_spawn, max_items_to_spawn)
	var full_rooms := 0 #to not loop if there are no more spawn points
	while(number_of_items > 0):
		for room in instantiated_rooms:
			if room.item_spawning_points.is_empty():
				full_rooms += 1
				if full_rooms >= instantiated_rooms.size():
					number_of_items = 0
					break
				continue
			room.item_spawning_points.shuffle()
			var new_item = items.pick_random().instantiate()
			items_father.add_child(new_item)
			new_item.position = room.item_spawning_points.pop_back()


func hide_cross() -> void:
	var new_rooms_array : Array
	for room in instantiated_rooms:
		new_rooms_array.append(room)
	
	new_rooms_array.shuffle()
	new_rooms_array.pop_back()
	
	for room in new_rooms_array:
		room.cross.queue_free()


func activate_randomizers() -> void:
	if not randomizer_container:
		return
	
	for randomizer in randomizer_container.get_children():
		if randomizer is Randomizer:
			randomizer.start_randomization()
			await randomizer.finish_randomization
			await get_tree().process_frame
