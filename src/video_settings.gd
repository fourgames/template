extends VBoxContainer

@onready var full_screen_option_button := $WindowModePanel/WindowModeButton
@onready var resolution_option_button := $ResolutionPanel/ResolutionBtn
@onready var scale_label := $ScalePanel/ProcentLabel
@onready var scale_slider := $ScalePanel/ScaleSlider
@onready var ScalePanel := $ScalePanel
@onready var vsync_option_button := $VsyncPanel/VsyncBtn
@onready var fsr_options := $AmdFsrPanel
@onready var screen_selector := $TargetDisplayPanel/TargetDisplayBtn
@onready var viewport_rid := get_tree().get_root().get_viewport_rid()

var Resolutions: Dictionary = {"3840X2160":Vector2i(3840,2160),
								"2560X1440":Vector2i(2560,1080),
								"1920X1080":Vector2i(1920,1080),
								"1366X768":Vector2i(1366,768),
								"1536X864":Vector2i(1536,864),
								"1280X720":Vector2i(1280,720),
								"1440X900":Vector2i(1440,900),
								"1600X900":Vector2i(1600,900),
								"1152X648":Vector2i(1152,648),
								"1024X600":Vector2i(1024,600),
								"800X600": Vector2i(800,600)}


func _ready() -> void:
	var video_settings = ConfigFileHandler.load_video_settings()
	%WindowModeButton.selected = video_settings.WindowMode
	#%TargetDisplayBtn.selected = video_settings.TargetDisplay
	#%ResolutionBtn.selected = video_settings.Resolution
	%FrameRateCapBtn.selected = video_settings.FrameRateCap
	%FPSCounterBtn.selected = video_settings.FPSCounter
	%VsyncBtn.selected = video_settings.Vsync
	%RenderScaleBtn.selected = video_settings.RenderingScalingMode
	%AmdFsrBtn.selected = video_settings.AmdFsr
	%ShadowsBtn.selected = video_settings.Shadows
	%ShadowQualityBtn.selected = video_settings.ShadowQuality
	%SsrBtn.selected = video_settings.Ssr
	%SsaoBtn.selected = video_settings.Ssao
	%SsilBtn.selected = video_settings.Ssil
	%SdfgiBtn.selected = video_settings.Sdfgi
	%GlowBtn.selected = video_settings.Glow
	%FogBtn.selected = video_settings.Fog
	%VolFogBtn.selected = video_settings.VolFog
	%MsaaBtn.selected = video_settings.Msaa
	%TaaBtn.selected = video_settings.Taa
	%SsaaBtn.selected = video_settings.Ssaa

	ConfigFileHandler.load_keybindings()
	Check_Variables()
	Add_Resolutions()
	Get_Screens()

	_on_window_mode_button_item_selected(video_settings.WindowMode)
	#_on_target_display_btn_item_selected(video_settings.TargetDisplay)
	#_on_resolution_btn_item_selected(video_settings.Resolution)
	_on_frame_rate_cap_btn_item_selected(video_settings.FrameRateCap)
	_on_fps_counter_btn_item_selected(video_settings.FPSCounter)
	_on_vsync_btn_item_selected(video_settings.Vsync)
	_on_render_scale_btn_item_selected(video_settings.RenderingScalingMode)
	_on_amd_fsr_btn_item_selected(video_settings.AmdFsr)
	#_on_scale_slider_value_changed(video_settings.WindowMode)
	_on_shadows_btn_item_selected(video_settings.Shadows)
	_on_shadow_quality_btn_item_selected(video_settings.ShadowQuality)
	_on_ssr_btn_item_selected(video_settings.Ssr)
	_on_ssao_btn_item_selected(video_settings.Ssao)
	_on_ssil_btn_item_selected(video_settings.Ssil)
	_on_sdfgi_btn_item_selected(video_settings.Sdfgi)
	_on_glow_btn_item_selected(video_settings.Glow)
	_on_fog_btn_item_selected(video_settings.Fog)
	_on_vol_fog_btn_item_selected(video_settings.VolFog)
	_on_msaa_btn_item_selected(video_settings.Msaa)
	_on_taa_btn_item_selected(video_settings.Taa)
	_on_ssaa_btn_item_selected(video_settings.Ssaa)


func Check_Variables():
	var _window = get_window()
	var mode = _window.get_mode()

	if mode == Window.MODE_FULLSCREEN:
		resolution_option_button.set_disabled(true)
		full_screen_option_button.set_pressed_no_signal(true)

	if DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED:
		vsync_option_button.set_pressed_no_signal(true)


func Set_Resolution_Text():
	var Resolution_Text = str(get_window().get_size().x)+"X"+str(get_window().get_size().y)
	resolution_option_button.set_text(Resolution_Text)
	
	scale_slider.set_value_no_signal(100.00)


func Add_Resolutions():
	var Current_Resolution = get_window().get_size()
	var ID = 0

	for r in Resolutions:
		resolution_option_button.add_item(r, ID)
		if Resolutions[r] == Current_Resolution:
			resolution_option_button.select(ID)
		ID += 1


func Centre_Window():
	var Centre_Screen = DisplayServer.screen_get_position()+DisplayServer.screen_get_size()/2
	var Window_Size = get_window().get_size_with_decorations()
	get_window().set_position(Centre_Screen-Window_Size/2)


func Get_Screens():
	var Screens = DisplayServer.get_screen_count()
	for s in Screens:
		screen_selector.add_item("SCREEN: "+str(s))


func _on_window_mode_button_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("WindowMode", index)
	resolution_option_button.set_disabled(index==0)
	match index:
		0: ## Fullscreen
			get_window().set_mode(Window.MODE_FULLSCREEN)
			Set_Resolution_Text()
		1: ## Windowed
			get_window().set_mode(Window.MODE_WINDOWED)
			Centre_Window()
	get_tree().create_timer(.05).timeout.connect(Set_Resolution_Text)


func _on_target_display_btn_item_selected(index: int) -> void:
	## ConfigFileHandler.save_video_settings("TargetDisplay", index)
	var _window = get_window()
	var mode = _window.get_mode()
	_window.set_mode(Window.MODE_WINDOWED)
	_window.set_current_screen(index)
	if mode == Window.MODE_FULLSCREEN:
		_window.set_mode(Window.MODE_FULLSCREEN)


func _on_resolution_btn_item_selected(index: int) -> void:
	## ConfigFileHandler.save_video_settings("Resolution", index)
	var ID = resolution_option_button.get_item_text(index)
	get_window().set_size(Resolutions[ID])
	Set_Resolution_Text()
	Centre_Window()


func _on_frame_rate_cap_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("FrameRateCap", index)
	match index:
		0:
			Engine.max_fps = 30;
		1:
			Engine.max_fps = 60;
		2:
			Engine.max_fps = 144;
		3:
			Engine.max_fps = 240;
		4:
			Engine.max_fps = 0;


func _on_vsync_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Vsync", index)
	match index:
		0:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)


func _on_render_scale_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("RenderingScalingMode", index)
	var _viewport = get_viewport()
	match index:
		1:
			_viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_BILINEAR)
			scale_slider.set_editable(true)
			fsr_options.hide()
			ScalePanel.show()
		2:
			_viewport.set_scaling_3d_mode(Viewport.SCALING_3D_MODE_FSR2)
			scale_slider.set_editable(false)
			fsr_options.show()
			ScalePanel.hide()


func _on_amd_fsr_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("AmdFsr", index)
	match index:
		1:
			_on_scale_slider_value_changed(50.00)
		2:
			_on_scale_slider_value_changed(59.00)
		3:
			_on_scale_slider_value_changed(67.00)
		4:
			_on_scale_slider_value_changed(77.00)


func _on_scale_slider_value_changed(value: float) -> void:
	var Resolution_Scale = value/100.00
	#var Resolution_Text = str(round(get_window().get_size().x*Resolution_Scale))+"x"+str(round(get_window().get_size().y*Resolution_Scale))
	scale_label.set_text(str(value)+"%")
	get_viewport().set_scaling_3d_scale(Resolution_Scale)
	#print(Resolution_Scale, Resolution_Text)


func _on_shadows_btn_item_selected(index: int) -> void:
	#
	ConfigFileHandler.save_video_settings("Shadows", index)
	match index:
		0:
			Global.directional_light_3d.shadow_enabled = false
		1:
			Global.directional_light_3d.shadow_enabled = true


func _on_shadow_quality_btn_item_selected(index):
	
	ConfigFileHandler.save_video_settings("ShadowQuality", index)
	Global.directional_light_3d.directional_shadow_mode = index


func _on_ssr_btn_item_selected(index: int) -> void:
	
	ConfigFileHandler.save_video_settings("Ssr", index)
	match index:
		0:
			Global.world_environment.environment.ssr_enabled = false
		1:
			Global.world_environment.environment.ssr_enabled = true


func _on_ssao_btn_item_selected(index: int) -> void:
	
	ConfigFileHandler.save_video_settings("Ssao", index)
	match index:
		0:
			Global.world_environment.environment.ssao_enabled = false
		1:
			Global.world_environment.environment.ssao_enabled = true


func _on_ssil_btn_item_selected(index: int) -> void:
	
	ConfigFileHandler.save_video_settings("Ssil", index)
	match index:
		0:
			Global.world_environment.environment.ssil_enabled = false
		1:
			Global.world_environment.environment.ssil_enabled = true


func _on_sdfgi_btn_item_selected(index: int) -> void:
	
	ConfigFileHandler.save_video_settings("Sdfgi", index)
	match index:
		0:
			Global.world_environment.environment.sdfgi_enabled = false
		1:
			Global.world_environment.environment.sdfgi_enabled = true


func _on_glow_btn_item_selected(index: int) -> void:
	
	ConfigFileHandler.save_video_settings("Glow", index)
	match index:
		0:
			Global.world_environment.environment.glow_enabled = false
		1:
			Global.world_environment.environment.glow_enabled = true


func _on_msaa_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Msaa", index)
	match index:
		0:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_DISABLED)
		1:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_2X)
		2:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_4X)
		3:
			RenderingServer.viewport_set_msaa_3d(viewport_rid, RenderingServer.VIEWPORT_MSAA_8X)


func _on_taa_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Taa", index)
	match index:
		0:
			get_viewport().use_taa = false
		1:
			get_viewport().use_taa = true


func _on_ssaa_btn_item_selected(index: int) -> void:
	ConfigFileHandler.save_video_settings("Ssaa", index)
	match index:
		0:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
		1:
			get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED


func _on_load_pressed() -> void:
	ConfigFileHandler.load_video_settings()


func _on_tails_pressed() -> void:
	OS.shell_open("https://discord.com/users/364076254812438538")


func _on_crab_pressed() -> void:
	OS.shell_open("https://discord.com/users/725764760615911545")


func _on_sucellos_pressed() -> void:
	OS.shell_open("https://discord.com/users/176082123738841088")


func _on_fps_counter_btn_item_selected(index):
	ConfigFileHandler.save_video_settings("FPSCounter", index)
	match index:
		0: 
			Global.FPSCounter = false
		1: 
			Global.FPSCounter = true


func _on_fog_btn_item_selected(index: int) -> void:
	
	ConfigFileHandler.save_video_settings("Fog", index)
	match index:
		0:
			Global.world_environment.environment.fog_enabled = false
		1:
			Global.world_environment.environment.fog_enabled = true


func _on_vol_fog_btn_item_selected(index: int) -> void:
	
	ConfigFileHandler.save_video_settings("VolFog", index)
	match index:
		0:
			Global.world_environment.environment.volumetric_fog_enabled = false
		1:
			Global.world_environment.environment.volumetric_fog_enabled = true


func _on_reset_button_pressed() -> void:
	OS.shell_open("https://discord.gg/bQTPTc5Qrt")


func _on_preset_button_item_selected(index: int) -> void:
	match index:
		1:
			#_on_window_mode_button_item_selected(0)
			#_on_target_display_btn_item_selected(video_settings.TargetDisplay)
			#_on_resolution_btn_item_selected(video_settings.Resolution)
			#_on_frame_rate_cap_btn_item_selected(4)
			#_on_fps_counter_btn_item_selected(0)
			#_on_vsync_btn_item_selected(0)
			_on_render_scale_btn_item_selected(2)
			%RenderScaleBtn.selected = 2
			_on_amd_fsr_btn_item_selected(1)
			%AmdFsrBtn.selected = 1
			#_on_scale_slider_value_changed(video_settings.WindowMode)
			_on_shadows_btn_item_selected(1)
			%ShadowsBtn.selected = 1
			_on_shadow_quality_btn_item_selected(1)
			%ShadowQualityBtn.selected = 1
			_on_ssr_btn_item_selected(0)
			%SsrBtn.selected = 0
			_on_ssao_btn_item_selected(0)
			%SsaoBtn.selected = 0
			_on_ssil_btn_item_selected(0)
			%SsilBtn.selected = 0
			_on_sdfgi_btn_item_selected(0)
			%SdfgiBtn.selected = 0
			_on_glow_btn_item_selected(0)
			%GlowBtn.selected = 0
			_on_fog_btn_item_selected(0)
			%FogBtn.selected = 0
			_on_vol_fog_btn_item_selected(0)
			%VolFogBtn.selected = 0
			_on_msaa_btn_item_selected(0)
			%MsaaBtn.selected = 0
			_on_taa_btn_item_selected(0)
			%TaaBtn.selected = 0
			_on_ssaa_btn_item_selected(0)
			%SsaaBtn.selected = 0
		2:
			_on_render_scale_btn_item_selected(2)
			%RenderScaleBtn.selected = 2
			_on_amd_fsr_btn_item_selected(2)
			%AmdFsrBtn.selected = 2
			#_on_scale_slider_value_changed(video_settings.WindowMode)
			_on_shadows_btn_item_selected(1)
			%ShadowsBtn.selected = 1
			_on_shadow_quality_btn_item_selected(1)
			%ShadowQualityBtn.selected = 1
			_on_ssr_btn_item_selected(0)
			%SsrBtn.selected = 0
			_on_ssao_btn_item_selected(0)
			%SsaoBtn.selected = 0
			_on_ssil_btn_item_selected(0)
			%SsilBtn.selected = 0
			_on_sdfgi_btn_item_selected(0)
			%SdfgiBtn.selected = 0
			_on_glow_btn_item_selected(1)
			%GlowBtn.selected = 1
			_on_fog_btn_item_selected(0)
			%FogBtn.selected = 1
			_on_vol_fog_btn_item_selected(1)
			%VolFogBtn.selected = 0
			_on_msaa_btn_item_selected(0)
			%MsaaBtn.selected = 0
			_on_taa_btn_item_selected(0)
			%TaaBtn.selected = 0
			_on_ssaa_btn_item_selected(0)
			%SsaaBtn.selected = 0
		3:
			_on_render_scale_btn_item_selected(2)
			%RenderScaleBtn.selected = 2
			_on_amd_fsr_btn_item_selected(3)
			%AmdFsrBtn.selected = 3
			#_on_scale_slider_value_changed(video_settings.WindowMode)
			_on_shadows_btn_item_selected(1)
			%ShadowsBtn.selected = 1
			_on_shadow_quality_btn_item_selected(1)
			%ShadowQualityBtn.selected = 1
			_on_ssr_btn_item_selected(0)
			%SsrBtn.selected = 0
			_on_ssao_btn_item_selected(0)
			%SsaoBtn.selected = 0
			_on_ssil_btn_item_selected(0)
			%SsilBtn.selected = 0
			_on_sdfgi_btn_item_selected(1)
			%SdfgiBtn.selected = 1
			_on_glow_btn_item_selected(1)
			%GlowBtn.selected = 1
			_on_fog_btn_item_selected(1)
			%FogBtn.selected = 1
			_on_vol_fog_btn_item_selected(1)
			%VolFogBtn.selected = 1
			_on_msaa_btn_item_selected(0)
			%MsaaBtn.selected = 0
			_on_taa_btn_item_selected(0)
			%TaaBtn.selected = 0
			_on_ssaa_btn_item_selected(0)
			%SsaaBtn.selected = 0
		4:
			#_on_window_mode_button_item_selected(0)
			#_on_target_display_btn_item_selected(video_settings.TargetDisplay)
			#_on_resolution_btn_item_selected(video_settings.Resolution)
			#_on_frame_rate_cap_btn_item_selected(4)
			#_on_fps_counter_btn_item_selected(0)
			#_on_vsync_btn_item_selected(0)
			_on_render_scale_btn_item_selected(2)
			%RenderScaleBtn.selected = 2
			_on_amd_fsr_btn_item_selected(4)
			%AmdFsrBtn.selected = 4
			#_on_scale_slider_value_changed(video_settings.WindowMode)
			_on_shadows_btn_item_selected(1)
			%ShadowsBtn.selected = 1
			_on_shadow_quality_btn_item_selected(2)
			%ShadowQualityBtn.selected = 2
			_on_ssr_btn_item_selected(1)
			%SsrBtn.selected = 1
			_on_ssao_btn_item_selected(1)
			%SsaoBtn.selected = 1
			_on_ssil_btn_item_selected(1)
			%SsilBtn.selected = 1
			_on_sdfgi_btn_item_selected(1)
			%SdfgiBtn.selected = 1
			_on_glow_btn_item_selected(1)
			%GlowBtn.selected = 1
			_on_fog_btn_item_selected(1)
			%FogBtn.selected = 1
			_on_vol_fog_btn_item_selected(1)
			%VolFogBtn.selected = 1
			_on_msaa_btn_item_selected(3)
			%MsaaBtn.selected = 3
			_on_taa_btn_item_selected(1)
			%TaaBtn.selected = 1
			_on_ssaa_btn_item_selected(1)
			%SsaaBtn.selected = 1
