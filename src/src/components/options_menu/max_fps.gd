extends HSplitContainer

func _ready() -> void:
	# 1. Slider (Live Update UI, but don't save to file every millisecond)
	%MaxFPSHSlider.value_changed.connect(_on_max_fps_h_slider_value_changed)
	
	# 2. LineEdit (Enter and Focus Exit)
	%MaxFPSLineEdit.text_submitted.connect(_on_max_fps_line_edit_text_submitted)
	%MaxFPSLineEdit.focus_exited.connect(func(): _on_max_fps_line_edit_text_submitted(%MaxFPSLineEdit.text))
	
	# 3. Reset
	%MaxFPSResetButton.pressed.connect(_on_max_fps_reset_button_pressed)
	
	%MaxFPSLineEdit.max_length = 3
	
	# INITIALIZE: Start the game with saved settings
	_finalize_fps_change(DataManager.payload.video.MaxFPS)

func _finalize_fps_change(value: int) -> void:
	# 1. Engine
	Engine.max_fps = value
	
	# 2. Data
	DataManager.payload.video.MaxFPS = value
	DataManager.save_data()
	
	# 3. UI Sync
	%MaxFPSHSlider.set_value_no_signal(value)
	%MaxFPSLineEdit.text = str(value)
	%MaxFPSResetButton.visible = (value != DataManager.payload.video.DefaultMaxFPS)

# --- SIGNAL HANDLERS ---

func _on_max_fps_h_slider_value_changed(value: float) -> void:
	var new_fps = int(value)
	%MaxFPSLineEdit.text = str(new_fps)
	Engine.max_fps = new_fps
	
	# ADD THIS LINE: Update the reset button visibility while sliding
	%MaxFPSResetButton.visible = (new_fps != DataManager.payload.video.DefaultMaxFPS)

func _on_max_fps_line_edit_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		var new_fps = clampi(new_text.to_int(), 0, 500)
		_finalize_fps_change(new_fps)
	else:
		# If invalid, go back to what the engine is actually doing
		%MaxFPSLineEdit.text = str(Engine.max_fps)
		# Trigger visibility check just in case
		%MaxFPSResetButton.visible = (Engine.max_fps != DataManager.payload.video.DefaultMaxFPS)

func _on_max_fps_reset_button_pressed() -> void:
	# Ensure the focus is removed so the LineEdit doesn't "fight" the reset
	%MaxFPSResetButton.release_focus()
	
	var default_val = DataManager.payload.video.DefaultMaxFPS
	print("Resetting to: ", default_val) # Debug check
	_finalize_fps_change(default_val)
	%MaxFPSLineEdit.grab_focus()
