extends HSplitContainer

func _ready() -> void:
	# 1. Connect all the signals
	%MaxFPSHSlider.value_changed.connect(_on_max_fps_h_slider_value_changed)
	%MaxFPSLineEdit.text_submitted.connect(_on_max_fps_line_edit_text_submitted)
	%MaxFPSResetButton.pressed.connect(_on_max_fps_reset_button_pressed)
	
# NEW: Connect the sliding window logic
	%MaxFPSLineEdit.text_changed.connect(_on_max_fps_line_edit_text_changed)
	# 2. Initialize the UI
	setup_fps_ui()



func setup_fps_ui() -> void:
	var saved_fps = DataManager.payload.video.MaxFPS
	
	# Update Slider and LineEdit to match saved data
	%MaxFPSHSlider.value = saved_fps
	%MaxFPSLineEdit.text = str(saved_fps)
	
	# Apply to the engine
	apply_fps_limit(saved_fps)

func apply_fps_limit(value: int) -> void:
	# Godot logic: 0 is uncapped
	Engine.max_fps = value
	
	# Update Label text for clarity
	if value == 0:
		%MaxFPSLabel.text = "Max FPS: Uncapped"
	else:
		%MaxFPSLabel.text = "Max FPS: " + str(value)
	
	# Save to DataManager
	DataManager.payload.video.MaxFPS = value
	DataManager.save_data()
	
	# Toggle Reset Button
	%MaxFPSResetButton.visible = (value != DataManager.payload.video.DefaultMaxFPS)

# --- Signal Handlers ---

func _on_max_fps_h_slider_value_changed(value: float) -> void:
	# Sliders use floats, but Engine.max_fps needs an int
	var new_fps = int(value)
	%MaxFPSLineEdit.text = str(new_fps)
	apply_fps_limit(new_fps)

func _on_max_fps_line_edit_text_submitted(new_text: String) -> void:
	# Ensure the input is a valid number
	if new_text.is_valid_int():
		var new_fps = clampi(new_text.to_int(), 0, 500) # Limit between 0 and 500
		%MaxFPSHSlider.value = new_fps
		apply_fps_limit(new_fps)
	else:
		# Reset text if they type garbage
		%MaxFPSLineEdit.text = str(%MaxFPSHSlider.value)

func _on_max_fps_reset_button_pressed() -> void:
	var default_fps = DataManager.payload.video.DefaultMaxFPS
	%MaxFPSHSlider.value = default_fps
	%MaxFPSLineEdit.text = str(default_fps)
	apply_fps_limit(default_fps)


func _on_max_fps_line_edit_text_changed(new_text: String) -> void:
	# 1. Store the current caret position before we mess with the text
	var old_caret_position = %MaxFPSLineEdit.caret_column
	
	# 2. Filter: Only allow numbers
	var filtered_text = ""
	for character in new_text:
		if character in "0123456789":
			filtered_text += character
	
	# 3. Sliding Window: Keep only the last 3 digits
	if filtered_text.length() > 3:
		filtered_text = filtered_text.right(3)
	
	# 4. Only update the LineEdit if the text actually changed
	# This prevents the "jumping" and infinite signal loops
	if %MaxFPSLineEdit.text != filtered_text:
		%MaxFPSLineEdit.text = filtered_text
		
		# Set caret to the end (standard for sliding input)
		# Or use: %MaxFPSLineEdit.caret_column = old_caret_position 
		# But for "sliding" text, jumping to the end feels more natural
		%MaxFPSLineEdit.caret_column = filtered_text.length()
	
	# 5. Live Apply (Engine and Slider sync)
	if filtered_text != "":
		var new_fps = clampi(filtered_text.to_int(), 0, 500)
		
		# We use set_value_no_signal so the slider doesn't 
		# trigger its own 'value_changed' and fight the LineEdit
		%MaxFPSHSlider.set_value_no_signal(new_fps)
		
		apply_fps_limit(new_fps)
