extends CanvasLayer



func _on_website_texture_button_pressed() -> void:
	OS.shell_open("https://fourgames.se")


func _on_play_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.PLAYING)


func _on_settings_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.OPTIONS_MENU)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
