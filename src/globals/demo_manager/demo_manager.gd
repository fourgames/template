@icon("uid://n7isbas4s1l3")
extends CanvasLayer


# Called when the node enters the scene tree for the first time.
# OPT can break it into 2 scripts and instance this scene but its only used in demo and if i did that just put autoplay on animation
func _ready() -> void:
	await $Timer.timeout
	get_tree().paused = true
	$AnimationPlayer.play("new_animation")
	
