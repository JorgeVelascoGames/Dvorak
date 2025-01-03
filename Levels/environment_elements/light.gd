extends Node3D

@export var is_tweaking_light := false

@onready var light_timer: Timer = $LightTimer
@onready var switch_sound: AudioStreamPlayer3D = $Switch/SwitchSound
@onready var position_lights: OmniLight3D = $Switch/PositionLights

const LIGHT_BUBBLE_SOUND = preload("res://Levels/environment_elements/light_bubble_sound.tscn")

var light_on := false
var lights_array : Array[Light3D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children(true):
		if child is Light3D:
			lights_array.append(child)
			var sound = LIGHT_BUBBLE_SOUND.instantiate() as AudioStreamPlayer3D
			child.add_child(sound)
	switch_light()
	tweak_light()


func on_switch_press() -> void:
	switch_light()
	
	#PLAY SOUND TODO
	
	if light_on:
		pass #play sound
	if light_on and is_tweaking_light:
		tweak_light()


func tweak_light() -> void:
	pass


func switch_light() -> void:
	light_on = !light_on
	for light in lights_array:
		light.visible = light_on
	position_lights.visible = !light_on


func _on_interactable_on_long_interact() -> void:
	on_switch_press()
