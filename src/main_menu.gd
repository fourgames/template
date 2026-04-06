extends CanvasLayer



func _on_website_texture_button_pressed() -> void:
	OS.shell_open("https://fourgames.se")


func _on_play_button_pressed() -> void:
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	GameManager.toggle_pause()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
