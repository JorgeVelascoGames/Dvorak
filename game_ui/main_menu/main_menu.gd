extends Node3D

@export var steam_url: String  ## La URL de la página de Steam


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	AppManager.game_manager.next_app_state()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
