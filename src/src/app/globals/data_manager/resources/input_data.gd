extends Resource
class_name InputData

@export var default_sensitivity := 50.0
@export var sensitivity := 50.0
# DataManager will populate this as the user makes changes.
@export var inpit_list : Array[Dictionary] = []
