extends CanvasLayer


func _ready() -> void:
	# Connecting the signals
	%WebsiteTextureButton.pressed.connect(_on_website_texture_button_pressed)
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%OptionsButton.pressed.connect(_on_settings_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)

func _on_website_texture_button_pressed() -> void:
	OS.shell_open("https://fourgames.se")


func _on_play_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.PLAYING)


func _on_settings_button_pressed() -> void:
	GameManager.change_state(GameManager.GameState.OPTIONS_MENU)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
