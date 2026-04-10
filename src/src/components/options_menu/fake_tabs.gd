extends HBoxContainer

# DOCS this is hacky but needed becuase issues with injecting audio and animations for real tabs

func _ready() -> void:
	%FakeTabVideo.pressed.connect(_on_fake_tab_pressed.bind(0))
	%FakeTabAudio.pressed.connect(_on_fake_tab_pressed.bind(1))
	%FakeTabInput.pressed.connect(_on_fake_tab_pressed.bind(2))
	%FakeTabCredits.pressed.connect(_on_fake_tab_pressed.bind(3))

func _on_fake_tab_pressed(current_tab_index: int):
	%TabContainer.current_tab = current_tab_index
