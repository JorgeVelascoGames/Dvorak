extends PlayerState
class_name PrepareGun

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var ammo_counter: AmmoCounter = $"../../Components/AmmoCounter"
@onready var animated_gun: Node3D = $"../../AnimatedObjects/GunModel"
@onready var animated_crowbar: Node3D = $"../../AnimatedObjects/Crowbar"
@onready var animation_tree: PlayerAnimationController = $"../../AnimationTree"
@onready var camera_pivot: Node3D = $"../../CameraPivot"
@onready var gun_initial_position := animated_gun.position

var tween : Tween
var crowbar_prepare := false

func enter(_msg : ={}) -> void:
	player.interactable_ray.process_mode = Node.PROCESS_MODE_DISABLED
	player.velocity = Vector3.ZERO
	
	if player.current_weapon == player.WEAPON.gun:
		ammo_counter.reload()
		animated_gun.show()
		animated_gun.position = Vector3(.3, 0.0, .2)
		tween = get_tree().create_tween()
		tween.set_parallel()
		var target_rotation = Vector3(-60, 0, 0) * deg_to_rad(1)
		tween.tween_property(animated_gun, "position", gun_initial_position, 0.6).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		tween.tween_property(camera_pivot, "rotation", target_rotation, 0.45)
		animation_tree["parameters/prepare_gun_trigger/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		await animation_tree.animation_finished
		#animation_player.play("prepare_gun")
		#await animation_player.animation_finished
		finish_prepare_gun()
	
	if player.current_weapon == player.WEAPON.crowbar:
		animated_crowbar.show()
		tween = create_tween()
		tween.tween_property(camera_pivot, "rotation", Vector3.ZERO, 0.6).set_ease(Tween.EASE_OUT)
		animated_crowbar.show()
		animation_tree["parameters/crowbar_prepare/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
		await animation_tree.animation_finished
		crowbar_prepare = true
	
	if player.current_weapon == player.WEAPON.none:
		state_machine.transition_to("Idle", {})


func update(_delta) -> void:
	if Input.is_action_just_released("aim"):
		if player.current_weapon == player.WEAPON.crowbar and crowbar_prepare:
			state_machine.transition_to("CrowbarSwing", {})
		else:
			state_machine.transition_to("Idle", {})
			animated_crowbar.hide()


func finish_prepare_gun() -> void:
	if player.current_weapon == player.WEAPON.gun:
		state_machine.transition_to("Aim", {})


func exit() -> void:
	if tween:
		tween.kill()
	animation_tree["parameters/prepare_gun_trigger/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	animation_tree["parameters/crowbar_prepare/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
	#animation_player.stop()
	animated_gun.hide()
	player.interactable_ray.process_mode = Node.PROCESS_MODE_INHERIT
	crowbar_prepare = false
