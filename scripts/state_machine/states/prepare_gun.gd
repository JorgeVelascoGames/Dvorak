extends PlayerState
class_name PrepareGun

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var animated_gun: MeshInstance3D = $"../../AnimatedObjects/AnimatedGun"


func enter(_msg : ={}) -> void:
	animated_gun.visible = true
	player.interactable_ray.process_mode = Node.PROCESS_MODE_DISABLED
	animation_player.play("prepare_gun")
	player.velocity = Vector3.ZERO
	await animation_player.animation_finished
	finish_prepare_gun()


func update(delta) -> void:
	if Input.is_action_just_released("aim"):
		state_machine.transition_to("Idle", {})


func finish_prepare_gun() -> void:
	state_machine.transition_to("Aim", {})


func exit() -> void:
	animated_gun.visible = false
	animation_player.stop()
	player.interactable_ray.process_mode = Node.PROCESS_MODE_INHERIT
