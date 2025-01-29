extends ColorRect
class_name VHSEffect

@onready var shader_mat : ShaderMaterial = get_material() as ShaderMaterial

var crease_noise_tween : Tween


func _ready() -> void:
	tween_crease_noise(2, 5)


func tween_crease_noise(amount : float, time : float) -> void:
	show()
	if crease_noise_tween:
		crease_noise_tween.kill()
	
	crease_noise_tween = get_tree().create_tween()
	crease_noise_tween.tween_method(_tween_crease_noise, shader_mat.get_shader_parameter("crease_noise"), amount, time)
	
	
func _tween_crease_noise(amount : float) -> void:
		shader_mat.set_shader_parameter("crease_noise", amount) 
