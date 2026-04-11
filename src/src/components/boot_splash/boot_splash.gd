extends CanvasLayer

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	if OS.is_debug_build():
		SceneChanger.change_scene.call_deferred(PathManager.GYM_SCENE)
	else:
		animation_player.play("boot_splash_animation")
		await animation_player.animation_finished
		SceneChanger.change_scene.call_deferred(PathManager.GYM_SCENE)
