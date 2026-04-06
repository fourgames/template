@tool
extends VBoxContainer

var is_remapping := false
var action_to_remap = null
var remapping_button = null

@onready var input_button_scene := preload("uid://j3c28gas5nsg")
@onready var action_list := self

var input_actions = {
	"move_forward": "MOVE FORWARD",
	"move_left": "MOVE LEFT",
	"move_backward": "MOVE BACKWARD",
	"move_right": "MOVE RIGHT",
	"choose": "CHOOSE",
}


func _ready() -> void:
	_load_keybindings_from_settings()
	_create_action_list()
	#var audio_settings = ConfigFileHandler.load_audio_settings() used this before but i want to load them not store this in a variable 
	ConfigFileHandler.load_audio_settings()
	#%MouseSensSlider.value = audio_settings.MouseSens
	#Global.mouse_sens = %MouseSensSlider.value
	
	#%CameraFOVSlider.value = audio_settings.CameraFOV
	#Global.camera_fov = %CameraFOVSlider.value


func _load_keybindings_from_settings():
	var keybindings = ConfigFileHandler.load_keybindings()
	for action in keybindings.keys():
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, keybindings[action])
		
	_apply_permanent_defaults()


func _create_action_list():
	for item in action_list.get_children():
		item.queue_free()

	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button, action))


func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."
	Global.input_update()


func _input(event: InputEvent) -> void:
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			# Turn double click into single click
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			
			InputMap.action_erase_events(action_to_remap)
			
			for action in input_actions:
				if InputMap.action_has_event(action, event):
					InputMap.action_erase_event(action, event)
					var buttons_with_action = action_list.get_children().filter(func(button):
						return button.find_child("LabelAction").text == input_actions[action]
						)
					for button in buttons_with_action:
						button.find_child("LabelInput").text = ""
			
			InputMap.action_add_event(action_to_remap, event)
			ConfigFileHandler.save_keybinding(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
	Global.input_update()


func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")
	Global.input_update()


func _on_reset_button_pressed() -> void:
	InputMap.load_from_project_settings()
	for action in input_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			ConfigFileHandler.save_keybinding(action, events[0])
	_create_action_list()
	Global.input_update()
	#_apply_permanent_defaults()


func _on_mouse_sens_slider_drag_ended(value_changed: bool) -> void:
	ConfigFileHandler.save_audio_settings("MouseSens", %MouseSensSlider.value)
	
	Global.mouse_sens = %MouseSensSlider.value


func _on_mouse_sens_slider_value_changed(value):
	%Label.set_text(str(%MouseSensSlider.value * 100) + "%")
	%FOVLabel.set_text(str(%CameraFOVSlider.value))
	
	Global.camera_fov = %CameraFOVSlider.value


func _on_camera_fov_slider_drag_ended(value_changed):
	ConfigFileHandler.save_audio_settings("CameraFOV", %CameraFOVSlider.value)

func _apply_permanent_defaults():
	var defaults = {
		"move_forward": [JOY_BUTTON_DPAD_UP, JOY_AXIS_LEFT_Y, -1.0, JOY_AXIS_RIGHT_Y, -1.0, KEY_UP],
		"move_backward": [JOY_BUTTON_DPAD_DOWN, JOY_AXIS_LEFT_Y, 1.0, JOY_AXIS_RIGHT_Y, 1.0, KEY_DOWN],
		"move_left": [JOY_BUTTON_DPAD_LEFT, JOY_AXIS_LEFT_X, -1.0, JOY_AXIS_RIGHT_X, -1.0, KEY_LEFT],
		"move_right": [JOY_BUTTON_DPAD_RIGHT, JOY_AXIS_LEFT_X, 1.0, JOY_AXIS_RIGHT_X, 1.0, KEY_RIGHT],
		"choose": [JOY_BUTTON_A] # JOY_BUTTON_A is constant for Button 0
	}

	for action in defaults:
		var data = defaults[action]
		
		# 1. Always add the primary Joypad Button (D-pad or Button 0)
		var joy_btn = InputEventJoypadButton.new()
		joy_btn.button_index = data[0]
		InputMap.action_add_event(action, joy_btn)
		
		# 2. Only add movement-specific inputs if they exist in the array
		if data.size() > 1:
			# Left Stick Axis
			var left_axis = InputEventJoypadMotion.new()
			left_axis.axis = data[1]
			left_axis.axis_value = data[2]
			InputMap.action_add_event(action, left_axis)
			
			# Right Stick Axis
			var right_axis = InputEventJoypadMotion.new()
			right_axis.axis = data[3]
			right_axis.axis_value = data[4]
			InputMap.action_add_event(action, right_axis)

			# Arrow Keys
			var arrow_key = InputEventKey.new()
			arrow_key.keycode = data[5]
			InputMap.action_add_event(action, arrow_key)
