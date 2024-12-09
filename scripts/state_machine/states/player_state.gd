extends State

class_name PlayerState

@export var cooldown := 0.0

var player : Player
var cooldown_timer : Timer ##0 for no cooldown

func _ready():
	await owner.ready
	player = owner as Player
	
	assert(player != null, "Invalid state node")
	
	if cooldown == 0:
		return
	cooldown_timer = Timer.new()
	cooldown_timer.wait_time = cooldown
	cooldown_timer.one_shot = true  
	add_child(cooldown_timer) 


func interact() -> void:
	pass
