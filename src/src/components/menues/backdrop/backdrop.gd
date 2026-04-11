extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play() -> void:
	$AnimationPlayer.play("fade_animation")

func play_backwards() -> void:
	$AnimationPlayer.play_backwards("fade_animation")
