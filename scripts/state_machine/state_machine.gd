extends Node
class_name StateMachine

signal  transitioned(state_name)

@export var initial_state := NodePath()
@export var debug_state_name := false
var state : State
var last_state : String

@onready var state_label = $"../PlayerUI/MarginContainer/StateLabel"
@onready var walker: WalkerModel = $"../WalkerFixedPoint/Walker"


func _ready():
	await owner.ready
	
	if not debug_state_name:
		state_label.hide()
	
	for child in get_children():
		child.state_machine = self
	
	transition_to(initial_state, {})


func _input(event: InputEvent) -> void:
	state.input(event)


func _unhandled_input(event):
	state._handle_input(event)


func _process(delta):
	state.update(delta)


func _physics_process(delta):
	state.physics_update(delta)


func transition_to(target_state_name : String, msg : Dictionary):
	if not has_node(target_state_name):
		return
	
	if get_node(target_state_name).cooldown_timer != null and get_node(target_state_name).cooldown_timer.time_left > 0:
		#TODO cd sound
		return
	
	if state != null:
		last_state = state.name
		state.exit()
		if state.cooldown_timer:
			state.cooldown_timer.start()
			
	
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	if debug_state_name:
		state_label.show()
		state_label.text = target_state_name


func get_state():
	return state.name as String
