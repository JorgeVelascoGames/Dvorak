extends VisibleOnScreenNotifier3D

@export var provoke_on_sight := true


func _on_screen_entered():
	owner.can_move = false
	if provoke_on_sight:
		owner.provoke = true


func _on_screen_exited():
	owner.can_move = true
