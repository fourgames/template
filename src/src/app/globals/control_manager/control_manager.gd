@icon("uid://b6ynqcq6i2vlo")
## GlobalUIManager
## 
## Automatically applies hover/press animation and sounds to all BaseButtons and Sliders.
## Setup: Project > Project Settings > Globals > Add this script as an Autoload.
extends Node

## Tracks active animations to prevent "tween fighting" when moving mouse quickly.
var _active_tweens: Dictionary = {}



	## Listens to everything being added
	## Uncomment if it misses nodes 
func _enter_tree() -> void:
	SignalManager.control_node_added.connect(_on_node_manager_received)
	
	#for node in get_tree().root.find_children("*", "Control", true, false):
		#_on_node_added(node)

## Filters added nodes and applies UI management logic to [Control] types.
func _on_node_manager_received(node: Node) -> void:
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
		AudioManager.play_sound(PathManager.UI_HOVER_SOUND)
	elif type == "press":
		AudioManager.play_sound(PathManager.UI_PRESS_SOUND)
	
	_animate_button(node, type)



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
