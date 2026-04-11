extends CanvasLayer

func _ready() -> void:
	DataManager.load_data() # useful to load here for all the options so they dont have to load new changes load once right
	%CloseButton.grab_focus()

func _on_button_pressed() -> void:
	GameManager.change_state(GameManager.previous_state)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play() -> void:
	$AnimationPlayer.play("fade_animation")

func play_backwards() -> void:
	$AnimationPlayer.play_backwards("fade_animation")
