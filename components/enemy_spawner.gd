extends Marker3D
class_name EnemySpawner

@export var start_spawn_on_ready := false ##If true, the spawner starts working on _ready
@export var spawn_countdown := 0.0 ##If the timer is over 0, it will spawn on loop
@export var scene_to_spawn : PackedScene
@export var node_to_parent : Node ##The node in which the spawned node will be nested. If empty, its nested on the root

@onready var spawn_timer: Timer = $SpawnTimer
@onready var visible_on_screen_notifier_3d: VisibleOnScreenNotifier3D = $VisibleOnScreenNotifier3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if start_spawn_on_ready:
		spawn()


func spawn() -> void:
	if visible_on_screen_notifier_3d.is_on_screen():
		await visible_on_screen_notifier_3d.screen_exited
	
	var new_instance = scene_to_spawn.instantiate()
	
	if node_to_parent == null:
		node_to_parent = get_tree().root
	
	node_to_parent.add_child(new_instance)
	
	if spawn_countdown > 0.0:
		spawn_timer.start(spawn_countdown)


func _on_spawn_timer_timeout() -> void:
	spawn()
