extends CanvasLayer


func _on_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.PLAYING)
