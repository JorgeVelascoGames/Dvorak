extends Node3D
class_name ExitGate

signal pass_and_books_ready

#Export variables
@export var main_switch_cd := 30.0

@onready var player_ui : PlayerUI = get_tree().get_first_node_in_group("player_ui")

#Variables
var pass_switches :Array[PassSwitch]= []
var pass_code :Array[bool]= []
var pass_books :Array[PassBook]= []
var door_is_open := false
var are_books_ready := false

#Constants
const PASS_BOOK : PackedScene = preload("res://ExitGate/pass_book.tscn") as PackedScene

#Components
@onready var main_switch_cd_timer = $MainSwitchCdTimer


func _ready():
	set_random_pass()


func set_random_pass() -> void:
	for child in get_children():
		if child is PassSwitch:
			pass_switches.append(child)
	for member in pass_switches:
		var temp := true
		var rnd = randf()
		if rnd > 0.5:
			temp = false
		pass_code.append(temp)
		#Generate de books
		var book :PassBook = PASS_BOOK.instantiate() as PassBook
		add_child(book)
		book.set_up_book(temp, member.switch_index)
		pass_books.append(book)
	
	are_books_ready = true
	pass_and_books_ready.emit()


func check_solution() -> bool:
	$MainSwitch/SwitchSound.play()
	var index := 0
	for code in pass_code:
		if code != pass_switches[index].switch_active:
			$Gate/Alarm.play()
			print("SOLUTION IS INCORRECT")
			return false
		index +=1
	
	index = 0
	print("SOLUTION IS CORRECT")
	$MainSwitch/switch/AnimationPlayer.play("activating", .1)
	$Gate/GateInteractable.process_mode = Node.PROCESS_MODE_DISABLED
	return true


func distribute_books(spawn_points : Array[Marker3D]) -> void:
	var i := 0
	spawn_points.shuffle()
	for book in pass_books:
		book.global_transform = spawn_points[i].global_transform
		#book.rotation = spawn_points[i].rotation
		i += 1


##Check if the code is correct
func _on_interactable_on_interact():
	print("press main switch...")
	if main_switch_cd_timer.time_left > 0:
		#SOUND
		player_ui.display_gameplay_text("The switch is locked for %d more seconds" %main_switch_cd_timer.time_left, 3)
		return
	main_switch_cd_timer.start(main_switch_cd)
	print(check_solution())
	if check_solution():
		door_is_open = true #OPEN DOOR
		player_ui.display_gameplay_text("The doors are unlocked. Use them to continue", 4)
	else:
		AppManager.game_manager.on_calamity.emit()
		player_ui.display_gameplay_text("The combination is incorrect. Now everyone knows you've returned...", 4)


func _on_gate_interactable_on_interact():
	if door_is_open:
		AppManager.game_manager.current_level_manager.finish_level()
	else:
		player_ui.display_gameplay_text("It's locked", 3)
