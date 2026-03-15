@icon("uid://81fmijj0c7h0")
extends Sprite3D
class_name HealthBarComponent

# TODO FIND AND GET THEMES AGAIN IN THIS COMP FOLDER

# TODO if negative damage then change first but if positive change oposite


@onready var health_progress_bar: ProgressBar = %HealthProgressBar
@onready var under_progress_bar: ProgressBar = %UnderProgressBar
@onready var wait_timer: Timer = %WaitTimer

func _ready() -> void:
	health_progress_bar.value = health_progress_bar.max_value
	under_progress_bar.value = health_progress_bar.max_value
	
	#health_progress_bar.add_theme_stylebox_override("background", load("uid://kuw0m6acholl"))
	#health_progress_bar.add_theme_stylebox_override("fill", load("uid://cljc642ndq70v"))
	#
	#under_progress_bar.add_theme_stylebox_override("background", load("uid://xafwcgqcyvwy"))
	#under_progress_bar.add_theme_stylebox_override("fill", load("uid://cxc3y1u6v10h"))

# NEXT taking damage works perfectly but heeling its bugged only under part moves maybe check other scripts
func apply_health_bar(amount: int, health_component: HealthComponent) -> void:
	health_progress_bar.max_value = health_component.max_health
	under_progress_bar.max_value = health_progress_bar.max_value
	## Damage is -amount
	if amount < 0: 
		health_progress_bar.value = health_component.health
		
	## Healing is amount
	elif amount > 0:
		under_progress_bar.value = health_component.health
		
	wait_timer.start()


func _on_wait_timer_timeout() -> void:
	# If its more then that means it healed
	if health_progress_bar.value > under_progress_bar.value:
		health_progress_bar.value = under_progress_bar.value
	# If its less that means it took damage
	elif health_progress_bar.value < under_progress_bar.value:
		under_progress_bar.value = health_progress_bar.value
