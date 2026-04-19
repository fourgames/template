@icon("uid://deb6kvmuw5vgc")
extends Node3D

class_name NumbersComponent

func set_and_play(value):
	var text = abs(int(value))

	if value > 0:
		%RichTextLabel.text = "[color=green]" + str(text)
	elif value >= -122:
		%RichTextLabel.text = "[color=white]" + str(text)
	elif value >= -194:
		%RichTextLabel.text = "[color=yellow]" + str(text)
	elif value >= -266:
		%RichTextLabel.text = "[color=orange]" + str(text)
	else:
		%RichTextLabel.text = "[color=red]" + str(text)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"rise_and_fade":
			queue_free()
