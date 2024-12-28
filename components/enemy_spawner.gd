extends Marker3D
class_name EnemySpawner

##If true, the spawner starts working on _ready
@export var start_spawn_on_ready := false 
##If the timer is over 0, it will spawn on loop
@export var spawn_countdown := 0.0 
@export var scene_to_spawn : PackedScene
##The node in which the spawned node will be nested. If empty, its nested on the root
@export var node_to_parent : Node 

@onready var spawn_timer: Timer = $SpawnTimer
@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D
@onready var enemy_manager : EnemyManager = AppManager.game_manager.enemy_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_spawn_on_ready:
		spawn()
	if not node_to_parent:
		node_to_parent = self

func spawn() -> void:
	if visible_on_screen_notifier_3d.is_on_screen():
		await visible_on_screen_notifier_3d.screen_exited
	
	var new_instance = scene_to_spawn.instantiate()
	
	if node_to_parent == null:
		node_to_parent = get_tree().root
	
	node_to_parent.add_child(new_instance)
	new_instance.global_position = global_position
	
	if spawn_countdown > 0.0:
		spawn_timer.start(spawn_countdown)


func _on_spawn_timer_timeout() -> void:
	if enemy_manager._can_spawn_enemy():
		spawn()
