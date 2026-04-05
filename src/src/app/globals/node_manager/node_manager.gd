@icon("uid://c6t3bwxp8oxg1")
extends Node

# TODO this will listen to all nodes added and hook them up to other scripts if i want to mainly control 
func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if not node is Control: # Right now only care about control but can change later to include others
		return
	
	if node.has_meta(&"managed"): 
		return
	node.set_meta(&"managed", true)
	
	if node is Control:
		SignalManager.control_node_added.emit(node)
