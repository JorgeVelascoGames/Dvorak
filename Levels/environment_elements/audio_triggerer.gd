extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		$AudioStreamPlayer3D.play()
		$Area3D.monitoring = false
