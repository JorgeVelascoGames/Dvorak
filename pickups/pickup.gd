extends StaticBody3D

@export var ammount : int

func _on_interactable_on_interact():
	var player : Player = get_tree().get_first_node_in_group("player")
	player.ammo_handler.pick_up_ammo(ammount)
	#TODO
	#EMIT SOUND
	#SHOW TEXT
	queue_free()
