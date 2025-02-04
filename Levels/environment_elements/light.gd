extends Node3D

@export var is_tweaking_light := false
@export var light_original_intensity := 1.0 ##The light energy of every single light on this switch

@onready var light_timer: Timer = $LightTimer
@onready var switch_sound: AudioStreamPlayer3D = $Switch/SwitchSound
@onready var position_lights: OmniLight3D = $Switch/emergency_light/PositionLights
@onready var animation_player: AnimationPlayer = $Switch/PositionLights/AnimationPlayer
@onready var animation_tree: SwitchAnimation = $Switch/swich/AnimationTree
@onready var switch: StaticBody3D = $Switch

const LIGHT_BUBBLE_SOUND = preload("res://Levels/environment_elements/light_bubble_sound.tscn")

var light_on := true
var lights_array : Array[Light3D] = []
var twinkling_ligt_tween : Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children(true):
		if child is Light3D:
			child.light_energy = light_original_intensity
			lights_array.append(child)
			var sound = LIGHT_BUBBLE_SOUND.instantiate() as AudioStreamPlayer3D
			child.add_child(sound)
	switch_light()
	if is_tweaking_light:
		twink_light()
	AppManager.game_manager.on_calamity.connect(on_calamity)

func on_switch_press() -> void:
	switch_light()
	
	#PLAY SOUND TODO
	
	if light_on:
		pass #play sound
	else:
		if twinkling_ligt_tween:
			twinkling_ligt_tween.kill()
	if light_on and is_tweaking_light:
		twink_light()


func twink_light() -> void:
	for light in lights_array:
		twink_individual_light(light)


func twink_individual_light(light : Light3D) -> void:
	# Inicializamos la semilla de aleatoriedad
	randomize()
	while light_on:
		# Elegimos intervalos aleatorios para el 'apagado' y el 'encendido'
		var off_duration = randf_range(0.05, 0.2)
		var on_duration = randf_range(0.05, 0.3)
		
		# Creamos un Tween para "apagar" la luz gradualmente
		var twinkling_ligt_tween = create_tween()
		twinkling_ligt_tween.tween_property(light, "light_energy", 0.0, off_duration)
		# Esperamos a que termine esta animación
		await twinkling_ligt_tween.finished
		#Con esto hacemos que pueda quedarse todo a oscuras un momento
		if randf() > 0.9:
			await get_tree().create_timer(randf_range(4.0, 6.0)).timeout
		
		# Si la luz se apaga durante el Tween, salimos del bucle
		if not light_on:
			break
		# Creamos otro Tween para "encender" la luz gradualmente
		twinkling_ligt_tween = create_tween()
		twinkling_ligt_tween.tween_property(light, "light_energy", light_original_intensity, on_duration)
		# Esperamos a que termine esta animación
		await twinkling_ligt_tween.finished
		if randf() > 0.6:
			await get_tree().create_timer(randf_range(0.5, 6.0)).timeout


func switch_light() -> void:
	light_on = !light_on
	for light in lights_array:
		light.visible = light_on
		light.light_energy = light_original_intensity
	position_lights.visible = !light_on
	if light_on:
		animation_tree.switch_into_on_position()
		switch.collision_layer = 10
	else:
		animation_tree.switch_into_off_position()
		switch.collision_layer = 7


func on_calamity() -> void:
	light_on = false
	for light in lights_array:
		light.visible = light_on
		light.light_energy = light_original_intensity
	position_lights.visible = false
	
	animation_tree.switch_into_off_position()
	$Switch/CollisionShape3D.disabled = true
	


func _on_interactable_on_long_interact() -> void:
	on_switch_press()


func _on_interactable_on_start_long_interaction() -> void:
	animation_tree.start_moving_animation()


func _on_interactable_on_stop_long_interaction() -> void:
	animation_tree.switch_into_off_position()
