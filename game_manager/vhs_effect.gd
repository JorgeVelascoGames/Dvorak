extends ColorRect
class_name VHSEffect

@onready var shader_mat : ShaderMaterial = get_material() as ShaderMaterial

var crease_noise_tween : Tween
var tape_crease_smear_tween : Tween
var is_closing := false


func tween_crease_noise(amount : float, time : float) -> void:
	is_closing = false
	show()
	if crease_noise_tween:
		crease_noise_tween.kill()
	
	var noise = clampf(amount, 0, 2)
	
	crease_noise_tween = get_tree().create_tween()
	crease_noise_tween.tween_method(_tween_crease_noise,\
	 shader_mat.get_shader_parameter("crease_noise"), noise, time)


func _tween_crease_noise(amount : float) -> void:
		shader_mat.set_shader_parameter("crease_noise", amount) 


func tween_tape_crease_smear(amount : float, time : float) -> void:
	is_closing = false
	show()
	if tape_crease_smear_tween:
		tape_crease_smear_tween.kill()
	
	var smear = clampf(amount, 0, 2)
	
	tape_crease_smear_tween = get_tree().create_tween()
	tape_crease_smear_tween.tween_method(_tween_tape_crease_smear,\
	 shader_mat.get_shader_parameter("tape_crease_smear"), smear, time)


func _tween_tape_crease_smear(amount : float) -> void:
	shader_mat.set_shader_parameter("tape_crease_smear", amount)


##Use for closing the VHS overlay effect in a given time. Doesn't cause conflict if its reactivated by some effect before closing
func close_vhs_effect(time : float) -> void:
	is_closing = true
	tween_crease_noise(0, time)
	tween_tape_crease_smear(0, time)
	await get_tree().create_timer(time).timeout
	if is_closing:
		hide()
