extends VisibleOnScreenNotifier3D


func _on_screen_entered():
	owner.can_move = false


func _on_screen_exited():
	owner.can_move = true
