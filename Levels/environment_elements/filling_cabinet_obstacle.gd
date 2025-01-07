extends Node3D

enum LOOT {bullets, bateries, pills}

@onready var interactable: Interactable = $StaticBody3D/Interactable
@onready var animation_tree: AnimationTree = $AnimationTree


func select_loot() -> void:
	pass


func _on_interactable_on_long_interact() -> void:
	interactable.queue_free()
	#Open animation


func _on_interactable_on_stop_long_interaction() -> void:
	pass #back to close animation


func _on_interactable_on_start_long_interaction() -> void:
	pass #Force animation
