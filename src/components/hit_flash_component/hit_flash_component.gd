@icon("res://assets/textures/icon/zap.png")
@tool
extends Node
class_name HitFlashComponent

# NEXT Rework this fully to just get all the children of the model i select so i dont need to select all manualy
# TODO Hook this up to the hurtbox and make it optional maybe idk but still give warning

@export_tool_button("Hit Flash", "Callable") var hit_flash_button = hit_flash
@export var duration: float = 0.2:
	set(value):
		duration = max(value, 0.1)
@export var meshes: Array[MeshInstance3D]

func _ready() -> void:
	hit_flash()

func hit_flash():
	for mesh_instance in meshes:
		var mesh_resource = mesh_instance.mesh
		if mesh_resource:
			for surface_index in range(mesh_resource.get_surface_count()):
				var material = mesh_instance.get_active_material(surface_index)
				if material is StandardMaterial3D:
					mesh_instance.mesh.resource_local_to_scene = true
					material.resource_local_to_scene = true
					material.emission_enabled = true
					var tween = get_tree().create_tween()
					tween.tween_property(material, "emission", Color(1, 1, 1), duration / 2)
					tween.tween_property(material, "emission", Color(0, 0, 0), duration / 2)
