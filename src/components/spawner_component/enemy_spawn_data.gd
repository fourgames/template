extends Resource
class_name EnemySpawnData


@export var time_start : int = 0  # When the spawning window begins
@export var time_end : int = 0    # When the spawning window ends

@export var enemy_scene: PackedScene  # The scene resource to spawn (enemy prefab)

@export var total_enemies: int = 0  # Total enemies to spawn in this window
# Internal state
var spawned_enemies: int = 0
#@export var enemies_per_second : int = 1  # The number of enemies to spawn
#@export var add_seconds_delay : int = 0  # The amount to add to the spawn delay after each spawn
#
#var delay_counter : int = 0  # Counter tracking the spawn delay
#
#@export var debug_min: int = 1
