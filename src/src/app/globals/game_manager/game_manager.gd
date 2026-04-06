@icon("uid://cdmyxwtwjrli8")
extends Node


enum GameState { MAIN_MENU, PLAYING, PAUSE_MENU, OPTIONS_MENU }
var current_state: GameState = GameState.MAIN_MENU
var previous_state: GameState = GameState.MAIN_MENU

# Preload your scenes for performance
const MAIN_MENU = preload("uid://c3xcgc53ytkha")
const PAUSE_MENU = preload("uid://cvb3uocxvde1x")
const OPTIONS_MENU = preload("uid://dycmqmsylxp31")

var active_menu = null

func _ready():
	change_state(GameState.MAIN_MENU)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match current_state:
			GameState.MAIN_MENU:
				pass
			GameState.PLAYING:
				change_state(GameState.PAUSE_MENU)
			GameState.PAUSE_MENU:
				change_state(GameState.PLAYING)
			GameState.OPTIONS_MENU:
				match previous_state:
					GameState.MAIN_MENU:
						change_state(GameState.MAIN_MENU)
					GameState.PAUSE_MENU:
						change_state(GameState.PAUSE_MENU)
					
					

func change_state(new_state):
	if current_state != new_state:
		previous_state = current_state
		
	current_state = new_state
	
	# Clean up the old menu
	if active_menu:
		active_menu.queue_free()
	
	match current_state:
		GameState.MAIN_MENU:
			active_menu = MAIN_MENU.instantiate()
		GameState.PAUSE_MENU:
			active_menu = PAUSE_MENU.instantiate()
		GameState.OPTIONS_MENU:
			active_menu = OPTIONS_MENU.instantiate()
			
	if active_menu:
		add_child(active_menu)
