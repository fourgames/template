extends Node

func _ready() -> void:
	# 1. Load the data from disk
	DataManager.load_data()
	
	# 2. Connect Signals (No more clicking in the Editor Node tab!)
	%WindowModeOptionButton.item_selected.connect(_on_window_mode_option_button_item_selected)
	%WindowModeResetButton.pressed.connect(_on_window_mode_reset_button_pressed)
	
	# 3. Call your setup function so the buttons actually populate
	setup_window_mode_options()


func setup_window_mode_options() -> void:
	# Always clear first in case you call this twice (e.g., during a Reset)
	%WindowModeOptionButton.clear()
	
	var saved_mode_id = DataManager.payload.video.WindowMode
	var mode_names = ClassDB.class_get_enum_constants("Window", "Mode")
	
	for mode_name in mode_names:
		# Skip Minimized so players don't accidentally hide the game
		#if mode_name == "MODE_MINIMIZED":
			#continue
			
		var mode_value = ClassDB.class_get_integer_constant("Window", mode_name)
		var display_text = mode_name.trim_prefix("MODE_").capitalize()
		
		%WindowModeOptionButton.add_item(display_text, mode_value)
		
		# If this mode matches our save data, select it in the UI
		if mode_value == saved_mode_id:
			var current_index = %WindowModeOptionButton.item_count - 1
			%WindowModeOptionButton.select(current_index)
	
	# Finally, apply the saved mode to the actual window
	get_window().mode = saved_mode_id as Window.Mode
	
	%WindowModeResetButton.visible = (DataManager.payload.video.WindowMode != DataManager.payload.video.DefaultWindowMode)


func _on_window_mode_option_button_item_selected(index: int) -> void:
	var selected_id = %WindowModeOptionButton.get_item_id(index)
	
	# 1. Apply and Save
	get_window().mode = selected_id as Window.Mode
	DataManager.payload.video.WindowMode = selected_id
	DataManager.save_data()
	
	# 2. Toggle the Reset Button
	# It will be TRUE if they are different, FALSE if they are the same
	%WindowModeResetButton.visible = (selected_id != DataManager.payload.video.DefaultWindowMode)


func _on_window_mode_reset_button_pressed() -> void:
	%WindowModeOptionButton.select(DataManager.payload.video.DefaultWindowMode)
	_on_window_mode_option_button_item_selected(DataManager.payload.video.DefaultWindowMode)
	%WindowModeOptionButton.grab_focus()
