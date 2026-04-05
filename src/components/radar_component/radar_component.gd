@icon("uid://dtvo8xbs6l3rq")
extends Node3D

@export var target_group: String = "Player"

var detected_list: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 10.0
	timer.timeout.connect(_on_scan_timer_timeout)
	timer.start()

func _on_scan_timer_timeout():
	var potential_targets = get_tree().get_nodes_in_group(target_group)
	var new_list = []
	
	for target in potential_targets:
		#if TODO could make this a area3d to only add when in range
		new_list.append(target)
	
	detected_list = new_list
	print("RadarComponent found: ", detected_list.size())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
