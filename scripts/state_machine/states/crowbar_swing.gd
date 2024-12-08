extends PlayerState
class_name CrowbarSwing

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var ammo_counter: AmmoCounter = $"../../Components/AmmoCounter"
@onready var animated_gun: Node3D = $"../../AnimatedObjects/GunModel"


func enter(_msg : ={}) -> void:
	player.interactable_ray.process_mode = Node.PROCESS_MODE_DISABLED
	player.velocity = Vector3.ZERO


func update(_delta) -> void:
	if Input.is_action_just_released("aim"):
		state_machine.transition_to("Idle", {})


func exit() -> void:
	animation_player.stop()
	player.interactable_ray.process_mode = Node.PROCESS_MODE_INHERIT
