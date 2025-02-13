extends MeshInstance3D

signal dissolve_completed

var dissolve_amount = 0.0
var dissolve_material: ShaderMaterial

var tween: Tween


func trigger_dissolve(time : float) -> void:
	dissolve_material = material_override as ShaderMaterial
	dissolve_material.set_shader_parameter("dissolve_amount", 0.0)
	if tween:
		return
	
	tween = create_tween()
	tween.tween_property(dissolve_material, "shader_parameter/dissolve_amount", 1.0, time)
	dissolve_completed.emit()
