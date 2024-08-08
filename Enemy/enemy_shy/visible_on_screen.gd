extends VisibleOnScreenNotifier3D

@onready var enemy_shy = $".."



func _on_screen_entered():
	enemy_shy.can_move = false


func _on_screen_exited():
	enemy_shy.can_move = true
