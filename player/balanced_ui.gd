extends Control
class_name BalanceUI

@export var modulate_color_light : Color
@export var modulate_color_dark : Color
@onready var left_texture: TextureRect = $HBoxContainer/LeftTexture
@onready var right_texture: TextureRect = $HBoxContainer/RightTexture
@onready var h_box_container: HBoxContainer = $HBoxContainer

var swap_bool := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BalanceAnimationTimer.timeout.connect(twink_colors)
	h_box_container.hide()


func display_keys(key_1 : String, key_2 : String) -> void:
	key_1 = key_1.to_lower()
	key_1 = key_1.reverse()
	key_1 = key_1.left(1)
	key_2 = key_2.to_lower()
	key_2 = key_2.reverse()
	key_2 = key_2.left(1)
	h_box_container.show()
	$HBoxContainer/LeftTexture/LeftLable.text = key_1
	$HBoxContainer/RightTexture/RightLAble.text = key_2


func twink_colors() -> void:
	if swap_bool:
		left_texture.modulate = modulate_color_dark
		right_texture.modulate = modulate_color_light
	else:
		left_texture.modulate = modulate_color_light
		right_texture.modulate = modulate_color_dark
	swap_bool = !swap_bool
