extends Node

@onready var first_warning_timer: Timer = $FirstWarningTimer
@onready var second_warning_timer: Timer = $SecondWarningTimer
@onready var third_warning_timer: Timer = $ThirdWarningTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#aviso de que el equilibrio esta por encima del 50%
#aviso de que el equilibrio está por encima del 80%
#aviso de que el equilibrio está por encima del 90%

#aviso de que el equilibrio ha bajado a menos de 15%


func _on_balance_balance_added(amount: int) -> void:
	pass # Replace with function body.
