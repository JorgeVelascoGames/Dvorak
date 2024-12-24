extends AnimationTree
class_name EnemyAnimator

@onready var animations = self["parameters/playback"]


func play_dead_animation() -> Signal:
	animations.travel("rig|Die")
	return animation_finished
