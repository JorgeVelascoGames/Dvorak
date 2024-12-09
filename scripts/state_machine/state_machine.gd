extends Node
class_name StateMachine

signal  transitioned(state_name)

@export var initial_state := NodePath()

var state : State

@onready var state_label = $"../PlayerUI/MarginContainer/StateLabel"
@onready var walker: WalkerModel = $"../WalkerFixedPoint/Walker"


func _ready():
	await owner.ready
	
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
	
	if state != null:
		state.exit()
	
	state = get_node(target_state_name)
	state.enter(msg)
	emit_signal("transitioned", state.name)
	state_label.text = target_state_name


func get_state():
	return state.name as String
