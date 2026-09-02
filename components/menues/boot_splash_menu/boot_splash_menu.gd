extends CanvasLayer

const PLAYGROUND_SCENE = "uid://n4y2s8gdj1cu"

func _ready() -> void:
	if OS.is_debug_build():
		SceneChanger.change_scene(PLAYGROUND_SCENE)
	else: # test
		%AnimationPlayer.play("boot_splash_animation")
		await %AnimationPlayer.animation_finished
		SceneChanger.change_scene(PLAYGROUND_SCENE)
