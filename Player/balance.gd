extends Node
class_name Balance

@onready var balance_recovery_timer = $BalanceRecoveryTimer
@onready var balance_bar = $UI/BalanceBar
@onready var player = $"../.."

@export_category("Balance value parameters")
@export var max_balance:= 1500
@export var current_balance := 0
@export var leaving_walker_cost : int
@export var forward_movement_cost : int
@export var backward_movement_cost : int
@export var side_movement_cost : int
@export var rotation_cost_divident : int = 15
@export var preparing_gun_cost : int
@export var shooting_cost : int
@export var getting_hit_cost : int
@export var balance_recovery : int
@export var bonus_balance_recovery : int

var direction : Vector3


func _ready():
	balance_bar.max_value = max_balance
	update_ui()


func _process(delta):
	direction = player.direction(delta)
	if not direction:
		return
	
	if Input.is_action_pressed("move_forward"):
		add_balance(forward_movement_cost * delta)
	elif Input.is_action_pressed("move_back"):
		add_balance(backward_movement_cost * delta)
	
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		add_balance(side_movement_cost * delta)


func _input(event):
	if event is InputEventMouseMotion:
		current_balance += event.relative.length() / rotation_cost_divident
	
	if event.is_action_pressed("move_forward"):
		add_balance(forward_movement_cost)
	elif event.is_action_pressed("move_back"):
		add_balance(backward_movement_cost)
	
	if event.is_action_pressed("move_right") or event.is_action_pressed("move_left"):
		add_balance(side_movement_cost)


func add_balance(amount : int) -> void:
	current_balance += amount
	
	if current_balance > max_balance:
		current_balance = max_balance
		#try keep balance...
		#TODO
	
	update_ui()


func reset_balance() -> void:
	current_balance = 0
	update_ui()


func update_ui() -> void:
	balance_bar.value = current_balance


func _on_balance_recovery_timer_timeout():
	if direction:
		current_balance -= balance_recovery / 2 #We divide by 2 because the timer goes every 0.5 secs
	else:
		current_balance -= bonus_balance_recovery / 2
	if current_balance < 0:
		current_balance = 0
	update_ui()


func _on_state_machine_transitioned(state_name):
	if state_name == "Walker":
		balance_bar.hide()
	else:
		balance_bar.show()
		update_ui()
	
	if state_name == "PrepareGun":
		add_balance(preparing_gun_cost)
