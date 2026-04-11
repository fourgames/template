extends VBoxContainer

# Ensure this points to your row scene (the HSplitContainer one)
const INPUT_CONTAINER = preload("uid://dmbuwj1hlif3n")

func _ready() -> void:
	create_action_list()

func create_action_list() -> void:
	for child in get_children():
		child.queue_free()
	
	var actions = InputMap.get_actions()
	for action in actions:
		var action_name = String(action)
		if action_name.begins_with("ui_"): 
			continue
			
		var instance = INPUT_CONTAINER.instantiate()
		add_child(instance)
		
		# We call the function inside the row script
		if instance.has_method("set_action"):
			instance.set_action(action_name)
