extends Marker3D
class_name EnemySpawner

##If true, the spawner starts working on _ready
@export var start_spawn_on_ready := false 
##If the timer is over 0, it will spawn on loop
@export var spawn_countdown := 0.0 
@export var scene_to_spawn : PackedScene
##The node in which the spawned node will be nested. If empty, its nested on the root

@onready var node_to_parent = get_tree().get_first_node_in_group("level_manager").enemy_container 
@onready var spawn_timer: Timer = $SpawnTimer
@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var enemy_manager : EnemyManager = get_tree().get_first_node_in_group("enemy_manager")
@onready var detection_area: Area3D = $DetectionArea

var calamity := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if enemy_manager.no_enemies:
		return
	
	enemy_manager.spawners.append(self)
	if start_spawn_on_ready:
		spawn(true)
	AppManager.game_manager.on_calamity.connect(on_calamity)


func spawn(is_provoked = false) -> void:
	if not enemy_manager._can_spawn_enemy():
		return
	
	if visible_on_screen_notifier_3d.is_on_screen():
		await visible_on_screen_notifier_3d.screen_exited
	
	var new_instance = scene_to_spawn.instantiate()
	
	if node_to_parent == null:
		node_to_parent = get_tree().root
	
	node_to_parent.add_child(new_instance)
	new_instance.global_position = global_position
	new_instance.rotation = rotation
	new_instance.provoke = is_provoked
	
	if spawn_countdown > 0.0:
		spawn_timer.start(spawn_countdown)


func on_calamity() -> void:
	calamity = true
	spawn_countdown = 12
	spawn(true)


func _on_spawn_timer_timeout() -> void:
	if calamity:
		return
	
	if enemy_manager._can_spawn_enemy():
		spawn(true)
