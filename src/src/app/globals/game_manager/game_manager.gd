@icon("uid://cdmyxwtwjrli8")
extends Node


enum GameState { MAIN_MENU, PAUSED, PLAYING, GAMEOVER}
var current_state #:= GameState.MAIN_MENU

var is_input_enabled := true

var is_paused = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()
		print("1")


func toggle_pause():
	print("2")
	is_paused = !is_paused
	get_tree().paused = is_paused
