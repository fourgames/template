@icon("uid://6acok6fga2ud")
@tool
extends Node
class_name HitFlashComponent

# NEXT Rework this fully to just get all the children of the model i select so i dont need to select all manualy
# TODO Hook this up to the hurtbox and make it optional maybe idk but still give warning

@export_tool_button("Hit Flash", "Callable") var hit_flash_button = hit_flash
@export var duration: float = 0.2:
	set(value):
		duration = max(value, 0.1)
@export var root_node: Node3D

func _ready() -> void:
	hit_flash()

# Dont fully comprehend but it works
func hit_flash():
	if not root_node: return
	
	for node in [root_node] + root_node.find_children("*", "GeometryInstance3D"):
		if node is GeometryInstance3D:
			var material = node.material if "material" in node else node.get_active_material(0)
			
			if material is StandardMaterial3D:
				material.resource_local_to_scene = true
				material.emission_enabled = true
				var tween = get_tree().create_tween()
				tween.tween_property(material, "emission", Color(1, 1, 1), duration / 2)
				tween.tween_property(material, "emission", Color(0, 0, 0), duration / 2)
