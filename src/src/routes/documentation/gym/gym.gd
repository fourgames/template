@icon("uid://xrg0p8m7ymeb")
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DataManager.load_data()
	print("DataManager exaple: " + str(DataManager.payload.video.fullscreen))
	DataManager.payload.video.fullscreen = !DataManager.payload.video.fullscreen
	DataManager.save_data()
	
	print("DataManager exaple: " + str(DataManager.payload.video.fullscreen))
