extends Node3D
class_name BlinkerBody

@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var blinker_enemy: Enemy = $".."


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
	blink()
	blinker_enemy.can_move = true
	blinker_enemy.provoke = true
	#start sound


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	blinker_enemy.can_move = false
