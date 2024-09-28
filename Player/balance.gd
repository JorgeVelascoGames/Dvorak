extends Node
class_name Balance

@export var show_ui := false

#Exported variables
@export_category("Balance value parameters")
@export var max_balance:= 2000.00
@export var current_balance := 1.00
@export var leaving_walker_cost : float
@export var forward_movement_cost : float
@export var sprint_penalty := 130.00
@export var backward_movement_cost : float
@export var side_movement_cost : float
@export var rotation_cost_divident := 15.00
@export var preparing_gun_cost : float
@export var shooting_cost : float
@export var getting_hit_cost : float
@export var balance_recovery : float
@export var bonus_balance_recovery : float
@export var damaged_balance_penalty := 15.00

#Variables
var direction : Vector3
var balance_active: bool = true

#Components
@onready var balance_recovery_timer = $BalanceRecoveryTimer
@onready var balance_bar = $UI/BalanceBar
@onready var player = $"../.."
@onready var walk: Walk = $"../../StateMachine/Walk"


func _ready():
	balance_bar.max_value = max_balance
	update_ui()


func _process(delta):
	direction = player.direction(delta)
	if not direction:
		return
	
	if not balance_active:
		return
	
	var penalty := 0.0
	if walk.sprinting:
		penalty = sprint_penalty
	
	if Input.is_action_pressed("move_forward"):
		add_balance((forward_movement_cost + penalty) * delta)
	elif Input.is_action_pressed("move_back"):
		add_balance((backward_movement_cost + penalty) * delta)
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		add_balance((side_movement_cost + penalty) * delta)


func _input(event):
	if not balance_active:
		return
	
	if event is InputEventMouseMotion:
		current_balance += event.relative.length() / rotation_cost_divident
	
	if event.is_action_pressed("move_forward"):
		add_balance(forward_movement_cost)
	elif event.is_action_pressed("move_back"):
		add_balance(backward_movement_cost)
	
	if event.is_action_pressed("move_right") or event.is_action_pressed("move_left"):
		add_balance(side_movement_cost)
	
	if event.is_action_pressed("fire"):
		add_balance(shooting_cost)


func add_balance(amount : int) -> void:
	current_balance += amount
	if player.damaged:
		current_balance += amount * (damaged_balance_penalty / 100)
	
	if current_balance >= max_balance:
		reset_balance()
		player.state_machine.transition_to("Unbalanced", {})
	
	update_ui()


func reset_balance() -> void:
	current_balance = 1
	update_ui()


func update_ui() -> void:
	balance_bar.value = current_balance


func get_percentage() -> float:
	var percentage := 100.00
	var float_current_balance := current_balance as float
	var float_max_balance := max_balance as float
	percentage = (float_current_balance * 100) / float_max_balance
	
	return percentage


func _on_balance_recovery_timer_timeout():
	var objective_balance := current_balance
	
	if direction:
		objective_balance -= balance_recovery / 2 #We divide by 2 because the timer goes every 0.5 secs
	else:
		objective_balance -= bonus_balance_recovery / 2
	if objective_balance < 1:
		objective_balance = 1
	
	current_balance = lerpf(current_balance, objective_balance, 1.0)
	
	update_ui()


func _on_state_machine_transitioned(state_name):
	if state_name == "Walker" or state_name == "Unbalanced" or state_name == "Downed":
		balance_bar.hide()
		balance_active = false
	else:
		if show_ui:
			balance_bar.show()
		balance_active = true
	
	if state_name == "PrepareGun":
		add_balance(preparing_gun_cost)
	
	update_ui()
