extends Randomizer
class_name RandomizerInstance ##This class will chose one single scene from the array and spawn it on its position in the 3D world. 

@export var spawn_items: Array[PackedScene] = [] ## Array de escenas para spawnear
@export var chance_to_spawn_nothing: float = 0.0 ## Probabilidad de NO spawnear (0.0 a 1.0)
@export var parent_node: NodePath ## Nodo al que hacer hijo, opcional


func start_randomization() -> void:
	spawn()


func spawn():
	# Verificar si se debe spawnear algo o no
	if randf() > chance_to_spawn_nothing:
		print("No se spawneó nada.")
		return
	
	# Elegir un ítem al azar de la lista
	if spawn_items.is_empty():
		print("La lista de ítems está vacía. Nada que spawnear.")
		return
	
	var chosen_scene = spawn_items.pick_random()
	
	# Instanciar la escena seleccionada
	var instance = chosen_scene.instance()
	
	# Determinar si debe ser hijo de otro nodo o del spawner
	if parent_node:
		var parent = get_node_or_null(parent_node)
		if parent:
			parent.add_child(instance)
			queue_free() # Destruir el spawner si se especifica un nodo padre
		else:
			add_child(instance)
	else:
		add_child(instance)
	
	# Establecer la posición de la escena instanciada
	if instance is Node3D:
		instance.position = position
		instance.rotation = rotation
	finish_randomization.emit()
