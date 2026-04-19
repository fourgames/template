@icon("uid://5qj5fd1fkas2")
extends Node3D


@export var spawn_data_list: Array[EnemySpawnData] = []

var total_time: float = 0
var current_spawn : int = 0 
var spawn_points : Array [Marker3D]


# TODO Rework to make it also work with waves instead of only time make it more modular
# Maybe if start and end time is 0 it will be wave based idk or toggle on the resource
# Make the custom resource EnemySpawnDate better 
# Make it more simple start with 1 spawn point
# Give better names to nodes and func
func _ready() -> void:
	for i in get_children():
		if i is Marker3D:
			spawn_points.append(i)


func _process(delta: float) -> void:
	total_time += delta 
	
	for spawn_data in spawn_data_list:
		if not spawn_data: continue
		
		# Check if we are within the time window
		if total_time >= spawn_data.time_start and total_time <= spawn_data.time_end:
			if spawn_data.spawned_enemies < spawn_data.total_enemies:
				var duration = spawn_data.time_end - spawn_data.time_start
				
				# Use (total_enemies - 1) if you want the last one to spawn exactly at time_end
				# or just use total_enemies to spread them out evenly.
				var interval = duration / max(1, spawn_data.total_enemies)

				if total_time >= spawn_data.time_start + (spawn_data.spawned_enemies * interval):
					spawn_enemy(spawn_data)


func spawn_enemy(spawn_data):
	var new_enemy = spawn_data.enemy_scene.instantiate()
	add_child(new_enemy, true)
	new_enemy.global_transform.origin = get_next_position()
	spawn_data.spawned_enemies += 1


func get_next_position():
	var map_rid = get_tree().get_first_node_in_group("Navigation").get_navigation_map()

	for i in range(spawn_points.size()):
		var area = spawn_points[current_spawn]
		# 1. Capture the original height you want
		var target_height = area.global_transform.origin.y
		
		var candidate = area.global_transform.origin + Vector3(randf_range(-0.5, 0.5), 0, randf_range(-0.5, 0.5))
		var nearest = NavigationServer3D.map_get_closest_point(map_rid, candidate)

		current_spawn = (current_spawn + 1) % spawn_points.size()

		# 2. Use the NavMesh X and Z, but KEEP the Marker's Y (height)
		var final_pos = Vector3(nearest.x, target_height, nearest.z)

		# Relax the distance check so it actually triggers
		if nearest.distance_to(candidate) < 0.5:
			return final_pos

	# Fallback: maintain height here too
	return spawn_points[0].global_transform.origin


func _on_area_3d_body_exited(body: Node3D) -> void:
	if self.is_ancestor_of(body):
		var area = spawn_points[current_spawn]
		body.physics_interpolation_mode = PHYSICS_INTERPOLATION_MODE_OFF
		body.global_transform.origin = area.global_transform.origin + Vector3(randf_range(-0.5, 0.5), 0, randf_range(-0.5, 0.5))
		body.physics_interpolation_mode = PHYSICS_INTERPOLATION_MODE_ON
		current_spawn = (current_spawn + 1) % spawn_points.size() 
