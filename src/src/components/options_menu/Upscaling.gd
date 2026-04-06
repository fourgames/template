extends HSplitContainer

# The 5 standard FSR 2.2 presets + Native
const PRESETS = {
	"Native (Off)": 1.0,
	"Ultra Quality": 0.77,
	"Quality": 0.67,
	"Balanced": 0.59,
	"Performance": 0.50,
	"Ultra Performance": 0.33
}

func _ready() -> void:
	%UpscalingOptionButton.item_selected.connect(_on_upscaling_option_button_item_selected)
	%UpscalingResetButton.pressed.connect(_on_upscaling_reset_button_pressed)
	setup_upscaling_ui()

func setup_upscaling_ui() -> void:
	%UpscalingOptionButton.clear()
	var saved_scale = DataManager.payload.video.UpscalingScale
	
	# Add the presets to the dropdown
	for preset_name in PRESETS.keys():
		%UpscalingOptionButton.add_item(preset_name)
		# If this matches our saved scale, select it
		if is_equal_approx(PRESETS[preset_name], saved_scale):
			%UpscalingOptionButton.select(%UpscalingOptionButton.item_count - 1)
	
	apply_upscaling_preset(saved_scale)

func apply_upscaling_preset(scale_value: float) -> void:
	var vp = get_viewport()
	
	if scale_value >= 1.0:
		# BACK TO NATIVE: Turn off the heavy stuff
		vp.scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		vp.scaling_3d_scale = 1.0
		vp.use_taa = false # Or true if you want standard TAA
	else:
		# UPSCALING ON: Use FSR 2.2
		vp.scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2
		vp.scaling_3d_scale = scale_value
		vp.use_taa = true # Required for FSR2
	
	# Save values
	DataManager.payload.video.UpscalingMode = vp.scaling_3d_mode
	DataManager.payload.video.UpscalingScale = scale_value
	DataManager.save_data()

func _on_upscaling_option_button_item_selected(index: int) -> void:
	var preset_name = %UpscalingOptionButton.get_item_text(index)
	var scale_value = PRESETS[preset_name]
	apply_upscaling_preset(scale_value)

func _on_upscaling_reset_button_pressed() -> void:
	# Reset to Native (1.0)
	apply_upscaling_preset(1.0)
	# Update the UI selection
	for i in %UpscalingOptionButton.item_count:
		if %UpscalingOptionButton.get_item_text(i) == "Native (Off)":
			%UpscalingOptionButton.select(i)
			break
