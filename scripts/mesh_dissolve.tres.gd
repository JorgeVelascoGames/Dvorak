extends MeshInstance3D

signal dissolve_completed

var dissolve_amount = 0.0
var dissolve_material: ShaderMaterial

var tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dissolve_material = material_override as ShaderMaterial
	dissolve_material.set_shader_parameter("dissolve_amount", 0.0)


func trigger_dissolve(time : float) -> void:
	if tween:
		return
	
	tween = create_tween()
	tween.tween_property(dissolve_material, "shader_parameter/dissolve_amount", 1.0, time)
	dissolve_completed.emit()
