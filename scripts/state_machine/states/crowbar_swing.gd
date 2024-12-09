extends PlayerState
class_name CrowbarSwing

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var ammo_counter: AmmoCounter = $"../../Components/AmmoCounter"
@onready var animated_gun: Node3D = $"../../AnimatedObjects/GunModel"
@onready var timer: Timer = $Timer
@onready var animation_tree: PlayerAnimationController = $"../../AnimationTree"
@onready var crowbar: Node3D = $"../../AnimatedObjects/Crowbar"
@onready var crowbar_attack_hitbox: Area3D = $"../../CrowbarAttackHitbox"

@export var swing_duration := .3

func enter(_msg : ={}) -> void:
	player.interactable_ray.process_mode = Node.PROCESS_MODE_DISABLED
	player.velocity = Vector3.ZERO
	await get_tree().physics_frame
	crowbar_attack_hitbox.monitoring = true
	animation_tree["parameters/crowbar_swing/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	await animation_tree.animation_finished
	state_machine.transition_to("Idle", {})


func exit() -> void:
	crowbar.hide()
	player.interactable_ray.process_mode = Node.PROCESS_MODE_INHERIT
	crowbar_attack_hitbox.monitoring = false
