extends Node3D

@onready var directional_light_3d: DirectionalLight3D = $DirectionalLight3D
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var original_light_energy : float = directional_light_3d.light_energy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	directional_light_3d.light_energy = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interactable_on_interact() -> void:
	directional_light_3d.show()
	AppManager.game_manager.enemy_manager.spawn_blockers.append(self)
	var tween := get_tree().create_tween()
	tween.tween_property(directional_light_3d, "light_energy", 1.2, 0.4)
	await  tween.finished
	AppManager.game_manager.enemy_manager.kill_all_enemies()
	await get_tree().create_timer(20).timeout
	tween.tween_property(directional_light_3d, "light_energy", 1.2, 5.5)
	AppManager.game_manager.enemy_manager.spawn_blockers.erase(self)
