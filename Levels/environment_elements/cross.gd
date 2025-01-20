extends Node3D

@export var cross_light_duration := 20.0

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
	$StaticBody3D/CollisionShape3D.disabled = true
	AppManager.game_manager.enemy_manager.spawn_blockers.append(self)
	var tween := get_tree().create_tween()
	tween.tween_property(directional_light_3d, "light_energy", 1.2, 0.4)
	for body in $Area3D.get_overlapping_bodies():
		if body is Enemy:
			body.enemy_die()
	var player : Player = get_tree().get_first_node_in_group("player")
	player.heal_up()
	player.player_ui.display_gameplay_text("“I am the light of the world. Whoever follows me will not walk in darkness, but will have the light of life.”", 3)
	await  tween.finished
	await get_tree().create_timer(cross_light_duration).timeout
	tween.tween_property(directional_light_3d, "light_energy", 1.2, 5.5)
	AppManager.game_manager.enemy_manager.spawn_blockers.erase(self)
