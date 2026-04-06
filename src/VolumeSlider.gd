@tool
extends HSlider

@onready var VolumeLabel := %VolumeLabel
@export var bus_name : String

var bus_index : int


func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)
	var audio_settings = ConfigFileHandler.load_audio_settings()
	%MasterVolumeSlider.value = audio_settings.Master
	%MusicVolumeSlider.value = audio_settings.Music
	%SfxVolumeSlider.value = audio_settings.Sfx
	VolumeLabel.set_text(str(value*100)+"%")


@warning_ignore("shadowed_variable_base_class")
func _on_value_changed(value: float) -> void:
	VolumeLabel.set_text(str(value*100)+"%")
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)


@warning_ignore("shadowed_variable_base_class")
func _on_drag_ended(value_changed: bool) -> void:
	if %MasterVolumeSlider.value_changed:
		ConfigFileHandler.save_audio_settings("Master", %MasterVolumeSlider.value)

	if %MusicVolumeSlider.value_changed:
		ConfigFileHandler.save_audio_settings("Music", %MusicVolumeSlider.value)

	if %SfxVolumeSlider.value_changed:
		ConfigFileHandler.save_audio_settings("Sfx", %SfxVolumeSlider.value)
