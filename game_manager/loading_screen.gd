extends Control
class_name LoadingScreen

signal NewSceneLoaded(scene : Node)

var is_loading := false
var scene_loading


func _ready() -> void:
	hide()


func load_scene(scene : PackedScene):
	if is_loading:
		return
	
	is_loading = true
	show()
	scene_loading = scene.resource_path
	ResourceLoader.load_threaded_request(scene.resource_path)


func _process(delta: float) -> void:
	if not is_loading:
		return
	
	if ResourceLoader.THREAD_LOAD_LOADED:
		is_loading = false
		var new_scene = ResourceLoader.load_threaded_get(scene_loading).instantiate()
		NewSceneLoaded.emit(new_scene)
		hide()
