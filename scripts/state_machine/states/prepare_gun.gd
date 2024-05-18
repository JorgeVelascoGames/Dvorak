extends PlayerState
class_name PrepareGun


func enter(_msg : ={}) -> void:
	player.interactable_ray.process_mode = Node.PROCESS_MODE_DISABLED


func finish_state() -> void:
	state_machine.transition_to("Aim", {})


func exit() -> void:
	player.interactable_ray.process_mode = Node.PROCESS_MODE_INHERIT
