extends Decal

@export var play_face_out_anim := true
@export var textures : Array[Texture2D] = []

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if play_face_out_anim:
		animation_player.play("fade_out")
	texture_albedo = textures.pick_random()
	rotate_object_local(Vector3.UP, (randf() * 50.0))
