extends CanvasLayer



func _on_paused_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.PLAYING)

func _on_continue_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.PLAYING)


func _on_options_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.OPTIONS_MENU)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
