extends Node3D

@export var light_on := false
@export var is_tweaking_light := false

@onready var light_timer: Timer = $LightTimer
@onready var tweak_timer: Timer = $TweakTimer
@onready var switch_sound: AudioStreamPlayer3D = $Switch/SwitchSound

const LIGHT_BUBBLE_SOUND = preload("res://Levels/environment_elements/light_bubble_sound.tscn")

var lights_array : Array[Light3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children(true):
		if child is Light3D:
			lights_array.append(child)
			var sound = LIGHT_BUBBLE_SOUND.instantiate() as AudioStreamPlayer3D
			child.add_child(sound)
	switch_light(light_on)
	tweak_light()


func on_switch_press() -> void:
	light_on = !light_on
	switch_light(light_on)
	
	#PLAY SOUND TODO
	
	if light_on:
		pass #play sound
	if light_on and is_tweaking_light:
		tweak_light()


func tweak_light() -> void:
	while(light_on):
		var tweaking_interval := randi_range(3, 12)
		light_timer.start(tweaking_interval)
		await light_timer.timeout
		var number_of_tweaks := randi_range(2, 7)
		var light = lights_array.pick_random()
		
		for i in number_of_tweaks:
			light.visible = !light.visible #En lugar de eso, vamos a hacer con un tween que haga fade out
			#if light.visible: #TODO
				#light.get_child()
			var tweak_time := randf_range(0.3, 1.6)
			tweak_timer.start(tweak_time)
			await  tweak_timer.timeout
		switch_light()


func switch_light(active := true) -> void:
	for light in lights_array:
		light.visible = active


func alternate_lights() -> bool:
	for light in lights_array:
		light.visible = !light.visible
	return lights_array[0].visible


func _on_interactable_on_interact() -> void:
	on_switch_press()


func _on_interactable_on_long_interact() -> void:
	on_switch_press()
