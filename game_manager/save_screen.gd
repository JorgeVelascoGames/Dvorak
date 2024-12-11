extends Control

@onready var game_level_manager: GameLevelManager = $".."


func _on_next_level_button_pressed() -> void:
	game_level_manager.next_level()


func _on_save_and_quit_button_pressed() -> void:
	#save the game
	game_level_manager.back_to_main_menu()
