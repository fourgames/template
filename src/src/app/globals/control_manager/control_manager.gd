@icon("uid://b6ynqcq6i2vlo")
## GlobalUIManager
## 
## Automatically applies hover/press animation and sounds to all BaseButtons and Sliders.
## Setup: Project > Project Settings > Globals > Add this script as an Autoload.
extends Node

## Tracks active animations to prevent "tween fighting" when moving mouse quickly.
var _active_tweens: Dictionary = {}

## Audio Resources. Replace these UIDs with your own sound files.
const UI_PRESS_SOUND := preload("uid://bcb5yvaaabo3x")
const UI_HOVER_SOUND := preload("uid://cvb1ywtd23rgw")

## Audio player for hover sounds. Pre-configured with max polyphony.
@onready var hover_node := _setup_audio_node(UI_HOVER_SOUND)
## Audio player for press sounds. Pre-configured with max polyphony.
@onready var press_node := _setup_audio_node(UI_PRESS_SOUND)


	## Listens to everything being added
	## Uncomment if it misses nodes 
func _enter_tree() -> void:
	get_tree().node_added.connect(_on_node_added)
	
	#for node in get_tree().root.find_children("*", "Control", true, false):
		#_on_node_added(node)

## Filters added nodes and applies UI management logic to [Control] types.
func _on_node_added(node: Node) -> void:
	if not node is Control:
		return
	
	if node.has_meta(&"ui_managed"): 
		return
	node.set_meta(&"ui_managed", true)
	
	if node is BaseButton:
		node.pivot_offset_ratio = Vector2(0.5, 0.5)
		
		node.mouse_entered.connect(node.grab_focus)
		node.focus_entered.connect(_handle_ui_event.bind(node, "hover"))
		node.focus_exited.connect(_handle_ui_event.bind(node, "unhover"))
		
		node.button_down.connect(_handle_ui_event.bind(node, "press"))
		node.button_up.connect(_handle_ui_event.bind(node, "hover"))
	elif node is Slider:
		node.pivot_offset_ratio = Vector2(0.5, 0.5)
		
		node.mouse_entered.connect(node.grab_focus)
		node.focus_entered.connect(_handle_ui_event.bind(node, "hover"))
		node.focus_exited.connect(_handle_ui_event.bind(node, "unhover"))
		
		node.drag_started.connect(_handle_ui_event.bind(node, "press"))
		node.drag_ended.connect(_handle_ui_event.bind(node, "hover").unbind(1))


func _handle_ui_event(node: Control, type: String) -> void:
	if type == "hover":
		_play_audio(hover_node)
	elif type == "press":
		_play_audio(press_node)
	
	_animate_button(node, type)


## Creates and configures an AudioStreamPlayer. 
## [br]Note: Requires an audio bus named "Sfx" to exist in the project.
func _setup_audio_node(stream: AudioStream) -> AudioStreamPlayer:
	var audio_node = AudioStreamPlayer.new()
	
	audio_node.stream = stream
	audio_node.max_polyphony = 8
	audio_node.bus = &"Sfx"
	
	add_child(audio_node)
	return audio_node
	
## Subtle randomization for a more natural, "premium" feel.
func _play_audio(audio_node: AudioStreamPlayer) -> void:
	audio_node.pitch_scale = randf_range(0.98, 1.02)
	audio_node.volume_db = randf_range(-2.0, 0.0)
	
	audio_node.play()



## Handles the Tween logic. To change the "feel", uncomment the SOFT presets below.
func _animate_button(node: Control, type: String):
	if _active_tweens.has(node):
		_active_tweens[node].kill()
	
	var tween = node.create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	#var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_active_tweens[node] = tween
	
	match type:
		"hover":
			## SOFT: tween.tween_property(node, "scale", Vector2(1.1, 1.1), 0.16)
			tween.tween_property(node, "scale", Vector2(1.05, 1.05), 0.12)
		"unhover":
			## SOFT: tween.tween_property(node, "scale", Vector2.ONE, 0.12)
			tween.tween_property(node, "scale", Vector2.ONE, 0.1)
		"press":
			## SOFT: tween.tween_property(node, "scale", Vector2(0.95, 0.95), 0.08)
			## SOFT: tween.chain().tween_property(node, "scale", Vector2(1.1, 1.1), 0.12)
			tween.tween_property(node, "scale", Vector2(0.95, 0.95), 0.05)
			tween.chain().tween_property(node, "scale", Vector2(1.05, 1.05), 0.1)
			
	tween.finished.connect(func(): if is_instance_valid(node): _active_tweens.erase(node))
