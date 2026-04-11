extends HSplitContainer

@onready var primary_input_progress_bar: ProgressBar = %PrimaryInputProgressBar
@onready var secondary_input_progress_bar: ProgressBar = %SecondaryInputProgressBar

@onready var input_name_label = %InputLabel
@onready var input_reset_button: TextureButton = %InputResetButton

@onready var primary_input_button = %PrimaryInputButton
@onready var primary_input_texture_button = %PrimaryInputTextureButton

@onready var secondary_input_button = %SecondaryInputButton
@onready var secondary_input_texture_button = %SecondaryInputTextureButton

var action_name: String
var default_events: Array[InputEvent] = []
var is_rebind_primary: bool = false
var is_listening: bool = false

func _ready():
	# Connect button signals
	primary_input_button.pressed.connect(_on_primary_pressed)
	secondary_input_button.pressed.connect(_on_secondary_pressed)
	input_reset_button.pressed.connect(_on_reset_pressed)
	
	# Initial UI state
	primary_input_progress_bar.visible = false
	secondary_input_progress_bar.visible = false

func set_action(name: String):
	action_name = name
	input_name_label.text = name.capitalize()
	
	# Capture defaults only once
	if default_events.is_empty():
		default_events = InputMap.action_get_events(action_name)
		
	update_icons()

func _on_primary_pressed():
	start_listening(true)

func _on_secondary_pressed():
	start_listening(false)

func _on_reset_pressed():
	InputMap.action_erase_events(action_name)
	for event in default_events:
		InputMap.action_add_event(action_name, event)
	update_icons()

func start_listening(is_primary: bool):
	is_listening = true
	is_rebind_primary = is_primary
	
	# Visual feedback
	if is_primary:
		primary_input_progress_bar.visible = true
		primary_input_texture_button.modulate.a = 0.3
	else:
		secondary_input_progress_bar.visible = true
		secondary_input_texture_button.modulate.a = 0.3

func _input(event):
	if not is_listening: return
	
	# Ignore mouse movement
	if event is InputEventMouseMotion: return
	
	# 1. Handle Buttons, Keys, and Mouse Clicks
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton:
		if event.is_pressed():
			accept_new_event(event)

	# 2. Handle Joystick/Trigger Axes
	elif event is InputEventJoypadMotion:
		# Use a 0.5 threshold to ensure the user actually meant to move the stick
		if abs(event.axis_value) > 0.5:
			accept_new_event(event)

func accept_new_event(new_event: InputEvent):
	# Stop the event from propagating
	get_viewport().set_input_as_handled()
	
	rebind_action(new_event)
	
	# Reset state
	is_listening = false
	primary_input_progress_bar.visible = false
	secondary_input_progress_bar.visible = false
	primary_input_texture_button.modulate.a = 1.0
	secondary_input_texture_button.modulate.a = 1.0

func rebind_action(new_event: InputEvent):
	var events = InputMap.action_get_events(action_name)
	InputMap.action_erase_events(action_name)
	
	if is_rebind_primary:
		InputMap.action_add_event(action_name, new_event)
		if events.size() > 1:
			InputMap.action_add_event(action_name, events[1])
	else:
		# Keep first, replace second
		if events.size() > 0:
			InputMap.action_add_event(action_name, events[0])
		InputMap.action_add_event(action_name, new_event)
	
	update_icons()

func update_icons():
	# Standard buttons stay empty; icons do the talking
	primary_input_button.text = ""
	secondary_input_button.text = ""
	
	var events = InputMap.action_get_events(action_name)
	
	# Primary Icon Update
	if events.size() > 0:
		var p_path = ControllerIcons._convert_event_to_path(events[0])
		primary_input_texture_button.texture_normal = ControllerIcons.parse_path(p_path)
	else:
		primary_input_texture_button.texture_normal = null
	
	# Secondary Icon Update
	if events.size() > 1:
		var s_path = ControllerIcons._convert_event_to_path(events[1])
		secondary_input_texture_button.texture_normal = ControllerIcons.parse_path(s_path)
	else:
		secondary_input_texture_button.texture_normal = null
