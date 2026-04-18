@icon("uid://cdmyxwtwjrli8")
extends Node


enum GameState { MAIN_MENU, PLAYING, PAUSE_MENU, OPTIONS_MENU }
var current_state: GameState = GameState.MAIN_MENU
var previous_state: GameState = GameState.MAIN_MENU

# Preload your scenes for performance
const MAIN_MENU = preload("uid://c3xcgc53ytkha")
const PAUSE_MENU = preload("uid://cvb3uocxvde1x")
const OPTIONS_MENU = preload("uid://dycmqmsylxp31")


const BACKDROP = preload("uid://y4kvhvl3hkpp")
var backdrop = null

var active_menu = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# The options menu applies all settings on start this is janky but aligns with instance on demand 
	var invisible_options_instance = OPTIONS_MENU.instantiate()
	invisible_options_instance.visible = false
	add_child(invisible_options_instance)
	if not invisible_options_instance.is_node_ready():
		await invisible_options_instance.ready
	invisible_options_instance.queue_free()
	
	change_state(GameState.MAIN_MENU)
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match current_state:
			GameState.PLAYING:
				change_state(GameState.PAUSE_MENU)
			GameState.PAUSE_MENU:
				change_state(GameState.PLAYING)
			GameState.OPTIONS_MENU:
				# We simply tell it to go back to the previous state
				change_state(previous_state)

func change_state(new_state):
	# 1. Update History: Only update previous_state if we are actually moving to a NEW state
	if current_state != new_state:
		previous_state = current_state
	
	current_state = new_state
	
	# 2. Cleanup: Remove existing menu
	if active_menu:
		await active_menu.play_backwards()
		active_menu.queue_free()
		active_menu = null
	
	# Handle Backdrop (On-demand)
	if current_state == GameState.PLAYING:
		if backdrop: 
			await backdrop.play_backwards()
			backdrop.queue_free()
			backdrop = null
	elif !backdrop:
		backdrop = BACKDROP.instantiate()
		add_child(backdrop)
		backdrop.play()
		move_child(backdrop, 0)
	
	# 3. State Execution
	match current_state:
		GameState.MAIN_MENU:
			get_tree().paused = true
			active_menu = MAIN_MENU.instantiate()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		GameState.PLAYING:
			get_tree().paused = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			# No menu instantiated here
			
		GameState.PAUSE_MENU:
			get_tree().paused = true
			active_menu = PAUSE_MENU.instantiate()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
		GameState.OPTIONS_MENU:
			# We don't need to change pause logic here; 
			# it stays paused from whatever opened it
			active_menu = OPTIONS_MENU.instantiate()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
	# 4. Finalize
	if active_menu:
		add_child(active_menu)
		active_menu.play()
