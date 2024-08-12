extends VisibleOnScreenNotifier3D

@onready var enemy_shy = $".."
@export var provoke_on_sight := true


func _on_screen_entered():
	enemy_shy.can_move = false
	if provoke_on_sight:
		enemy_shy.provoke = true


func _on_screen_exited():
	enemy_shy.can_move = true
