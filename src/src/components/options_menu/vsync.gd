extends Node

func _ready() -> void:
	# 1. Connect Signals
	%VsyncOptionButton.item_selected.connect(_on_VsyncOptionButton_item_selected)
	%VsyncResetButton.pressed.connect(_on_VsyncResetButton_pressed)
	
	# 2. Setup the UI
	setup_vsync_options()

func setup_vsync_options() -> void:
	%VsyncOptionButton.clear()
	
	var saved_vsync_id = DataManager.payload.video.VSyncMode
	# We look inside DisplayServer for the VSyncMode enum
	var mode_names = ClassDB.class_get_enum_constants("DisplayServer", "VSyncMode")
	
	for mode_name in mode_names:
		var mode_value = ClassDB.class_get_integer_constant("DisplayServer", mode_name)
		
		# Format text: VSYNC_ENABLED -> Enabled
		var display_text = mode_name.trim_prefix("VSYNC_").capitalize()
		%VsyncOptionButton.add_item(display_text, mode_value)
		
		if mode_value == saved_vsync_id:
			%VsyncOptionButton.select(%VsyncOptionButton.item_count - 1)
	
	# Apply to the engine and set initial button visibility
	DisplayServer.window_set_vsync_mode(saved_vsync_id as DisplayServer.VSyncMode)
	%VsyncResetButton.visible = (saved_vsync_id != DataManager.payload.video.DefaultVSyncMode)

func _on_VsyncOptionButton_item_selected(index: int) -> void:
	var selected_id = %VsyncOptionButton.get_item_id(index)
	
	# 1. Apply to Engine
	DisplayServer.window_set_vsync_mode(selected_id as DisplayServer.VSyncMode)
	
	# 2. Save Data
	DataManager.payload.video.VSyncMode = selected_id
	DataManager.save_data()
	
	# 3. Toggle Reset Button
	%VsyncResetButton.visible = (selected_id != DataManager.payload.video.DefaultVSyncMode)
	
	print("Current VSync Mode (ID): ", DisplayServer.window_get_vsync_mode())

func _on_VsyncResetButton_pressed() -> void:
	var default_id = DataManager.payload.video.DefaultVSyncMode
	
	%VsyncOptionButton.grab_focus()
	# Find the index that matches our default ID
	for i in %VsyncOptionButton.item_count:
		if %VsyncOptionButton.get_item_id(i) == default_id:
			%VsyncOptionButton.select(i)
			_on_VsyncOptionButton_item_selected(i)
			break
