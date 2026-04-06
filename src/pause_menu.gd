extends ColorRect

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var pause_menu: Control = %PauseMenu
@onready var pausemenu: Control = %PauseMenu
@onready var options = %Options
#@onready var unstuck_timer: Timer = $UnstuckTimer

func _unhandled_input(event: InputEvent) -> void:
	if Global.input == true:
		if event.is_action_pressed("ui_cancel"):
			if self.visible == true:
				unpause()
			if %PauseMenu.visible == false:
				%PauseMenu.show()
				%PauseMenu.pause()

func show_and_hide(first, second):
	first.show()
	second.hide()

func _ready() -> void:
	if %WishlistBtn.visible == true:
		Global.demo = true
		%WishlistMargin.visible = true
	else:
		%WishlistMargin.visible = false
	%Options.hide()
	
	if get_tree().current_scene.name == "world_1_hub_1":
		%ExitLevelBtn.hide()
		%QuitBtn.show()
	elif get_tree().current_scene.name == "world_1_tutorial_1":
		%ExitLevelBtn.hide()
		%QuitBtn.show()
	else:
		%ExitLevelBtn.show()
		#%QuitBtn.hide() // TODO This should kidna be hidden but for debug i allways show it

	_connect_buttons_recursively(self)

func _connect_buttons_recursively(node: Node) -> void:
	for child in node.get_children():
		if child is Button:
			child.mouse_entered.connect(_all_btn_mouse_entered.bind(child))
		
		# If this child has its own children, look inside them too
		if child.get_child_count() > 0:
			_connect_buttons_recursively(child)

func _all_btn_mouse_entered(btn: Button) -> void:
	btn.grab_focus()

func unpause():
	get_tree().paused = false
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animator.play_backwards("fade")
	await animator.animation_finished
	self.visible = false
	#%ContinueBtn.disabled = true
	
func pause():
	
	animator.play("fade")
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	get_tree().paused = true
	%ContinueBtn.grab_focus()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#%ContinueBtn.disabled = false


func _on_continue_btn_pressed():
	unpause()
	#get_parent().get_parent().get_node("Player").refresh_options()

func _on_exit_level_btn_pressed():
	ChangeScene.changeable = true
	unpause()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if get_tree().current_scene.name == "world_1_tutorial_1":
		ChangeScene.changeScene(ChangeScene.world_1_tutorial_1)
	else:
		ChangeScene.changeScene(ChangeScene.world_1_hub_1)

func _on_back_btn_pressed():
	animator.play_backwards("Options_Fade")
	await animator.animation_finished
	show_and_hide(pausemenu, options)
	%ContinueBtn.grab_focus()


func _on_option_btn_pressed() -> void:
	animator.play("Options_Fade")
	show_and_hide(options, pausemenu)
	%BackBtn.grab_focus()
	

func _on_unstuck_btn_pressed() -> void:
	get_parent().translate(Vector3(0, 1, 0))


func _on_wishlist_btn_pressed() -> void:
	OS.shell_open("steam://openurl/https://store.steampowered.com/app/2807130/")


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_discord_btn_pressed() -> void:
	OS.shell_open("https://discord.gg/bQTPTc5Qrt")
