extends Node3D
class_name BlinkerBody

@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var blinker_enemy: Enemy = $".."
@onready var hurt_box: Area3D = $"../HurtBox"


func _ready() -> void:
	pass


func blink() -> void:
	self.global_position = blinker_enemy.global_position
	self.rotation = blinker_enemy.rotation
	#Play animation maybe


func enemy_die() -> void:
	blinker_enemy.enemy_die()


func _on_hurt_box_body_entered(body: Node3D) -> void:
	if body is Player:
		blink()
		body.player_hit()


func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	blinker_enemy.can_move = true
	blinker_enemy.provoke = true
	hurt_box.monitoring = true
	#start sound


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	blinker_enemy.can_move = false
	hurt_box.monitoring = false
	blink()
