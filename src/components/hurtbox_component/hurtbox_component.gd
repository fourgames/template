@icon("uid://bw5fsmat1gbkh")
extends Area3D
class_name HurtboxComponent

@export var health_component: HealthComponent
@export var health_bar_component: HealthBarComponent
@export var hit_flash_component : HitFlashComponent


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if health_component == null:
		warnings.append("health_component isn't assigned.")

	if health_bar_component == null:
		warnings.append("health_bar_component isn't assigned.")

	if collision_layer == 0:
		warnings.append("A hurtbox should be on a layer")

	if collision_mask != 0:
		warnings.append("A hurtbox should not be on a mask")

	return warnings

func apply_health_change(amount: int):
	if _get_configuration_warnings().size() > 0:
		for error in _get_configuration_warnings():
			push_warning("Hurtbox Error at ", get_path(), ": ", error)
	
	if health_component:
		health_component.change_health(amount)
		if health_bar_component:
			health_bar_component.apply_health_bar(amount, health_component)
	
	# Maybe warnings for this but its kinda optinal maybe more safty checks if its not added
	if hit_flash_component:
		hit_flash_component.hit_flash()
