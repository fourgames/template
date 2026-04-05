@icon("uid://5qj5fd1fkas2")
extends Node3D

# TODO this works well but maybe make it more simple starting with 1 spawn point that you use this to spawn even player at start 

@export var spawn_data_list: Array[EnemySpawnData] = []



var total_time: float = 0

#@export var areas : Array [Area3D]

var current_spawn : int = 0 

var spawn_points : Array [Marker3D]

func _ready() -> void:
	for spawn_data in spawn_data_list:
		if spawn_data:
			# If it's 1, it stays 1. 
			# If it's 10, it becomes 5. 
			# If it's 3, it becomes 2.
			spawn_data.total_enemies = max(1, ceil(spawn_data.total_enemies / 2.0))
	for i in get_children():
		if i is Marker3D:
			spawn_points.append(i)


func _process(delta: float) -> void:
	total_time += delta  # total_time is now in seconds, with sub-second precision
	
	for spawn_data in spawn_data_list:
		if spawn_data == null:
			continue
		if total_time >= spawn_data.time_start and total_time <= spawn_data.time_end:
			if spawn_data.spawned_enemies < spawn_data.total_enemies:
				var duration = spawn_data.time_end - spawn_data.time_start
				var interval = float(duration) / float(spawn_data.total_enemies)

				# If enough time has passed for the next spawn
				if total_time >= spawn_data.time_start + (spawn_data.spawned_enemies * interval):
					var new_enemy = spawn_data.enemy_scene.instantiate()
					add_child(new_enemy, true)
					new_enemy.global_transform.origin = get_next_position()
					spawn_data.spawned_enemies += 1
#func _on_spawn_timer_timeout():
	#total_time += 1
	#for spawn_data in spawn_data_list:
		#if total_time >= spawn_data.time_start and total_time <= spawn_data.time_end:
			#if spawn_data.spawned_enemies < spawn_data.total_enemies:
				#var duration = spawn_data.time_end - spawn_data.time_start
				#var interval = float(duration) / float(spawn_data.total_enemies)
				#
				## Check if it’s time to spawn the next enemy
				#if total_time >= spawn_data.time_start + int(spawn_data.spawned_enemies * interval):
					#var new_enemy = spawn_data.enemy_scene.instantiate()
					#add_child(new_enemy, true)
					#new_enemy.global_transform.origin = get_next_position()
					#spawn_data.spawned_enemies += 1
	#
	#total_time += 1
	#for spawn_data in spawn_data_list:
		#if total_time >= spawn_data.time_start and total_time <= spawn_data.time_end:
			#if spawn_data.delay_counter < spawn_data.add_seconds_delay:
				#spawn_data.delay_counter += 1
			#else:
				#spawn_data.delay_counter = 0
				#var enemy_count = 0
				#while enemy_count < spawn_data.enemies_per_second:
					#var new_enemy = spawn_data.enemy_scene.instantiate()
					#add_child(new_enemy, true)
					#
					#new_enemy.global_transform.origin = get_next_position()
					##add_child(new_enemy)
					#enemy_count += 1
					#await get_tree().create_timer(randf_range(0.0, 0.0667)).timeout # 15TPS is every 0.0667s

func get_next_position():
	var map_rid = get_node("/root/Game/NavigationRegion3D2").get_navigation_map()

	for i in range(spawn_points.size()):
		var area = spawn_points[current_spawn]
		var candidate = area.global_transform.origin + Vector3(randf_range(-0.5, 0.5), 0, randf_range(-0.5, 0.5))
		var nearest = NavigationServer3D.map_get_closest_point(map_rid, candidate)

		current_spawn = (current_spawn + 1) % spawn_points.size()

		if nearest.distance_to(candidate) < 0.01:
			return candidate

	return spawn_points[0].global_transform.origin 

func _on_area_3d_body_exited(body: Node3D) -> void:
	if self.is_ancestor_of(body):
		var area = spawn_points[current_spawn]
		body.physics_interpolation_mode = PHYSICS_INTERPOLATION_MODE_OFF
		body.global_transform.origin = area.global_transform.origin + Vector3(randf_range(-0.5, 0.5), 0, randf_range(-0.5, 0.5))
		body.physics_interpolation_mode = PHYSICS_INTERPOLATION_MODE_ON
		current_spawn = (current_spawn + 1) % spawn_points.size() 
#func _on_area_3d_body_exited(body: Node3D) -> void: old shit skiped half the points and stupid for loop with break
	#if self.is_ancestor_of(body):
		#for i in spawn_points.size():
			#var area = spawn_points[current_spawn]
			##if area.get_overlapping_areas().is_empty(): old shit before new system
			#current_spawn = (current_spawn + 1) % spawn_points.size()
			#body.physics_interpolation_mode = PHYSICS_INTERPOLATION_MODE_OFF
			#body.global_transform.origin = area.global_transform.origin + Vector3(randf_range(-0.5, 0.5), 0, randf_range(-0.5, 0.5))
			#body.physics_interpolation_mode = PHYSICS_INTERPOLATION_MODE_ON
			#current_spawn = (current_spawn + 1) % spawn_points.size()
			#break
