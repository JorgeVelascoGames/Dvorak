extends Node3D
class_name ExitGate

signal on_calamity

#Export variables
@export var main_switch_cd := 30.0

#Variables
var pass_switches :Array[PassSwitch]= []
var pass_code :Array[bool]= []
var pass_books :Array[PassBook]= []
var door_is_open := false

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
		book.set_up_book(temp, member.switch_index)
		pass_books.append(book)



func check_solution() -> bool:
	var index := 0
	for code in pass_code:
		if code != pass_switches[index].switch_active:
			print("SOLUTION IS INCORRECT")
			return false
		index +=1
	
	index = 0
	print("SOLUTION IS CORRECT")
	return true


#Check if the code is correct
func _on_interactable_on_interact():
	print("press main switch...")
	if main_switch_cd_timer.time_left > 0:
		#SOUND
		return
	main_switch_cd_timer.start(main_switch_cd)
	print(check_solution())
	if check_solution():
		door_is_open = true #OPEN DOOR
	else:
		on_calamity.emit()


func _on_gate_interactable_on_interact():
	if door_is_open:
		print("LEVEL FINISHED")
		pass #NEXT LEVEL
