@tool
@icon("uid://yb2irimddrdm")
extends Node
class_name HealthComponent

@export var parent : Node
@export var max_health : int = 100
@export var health : int = 100

func change_health(amount : int):
	health += amount
	
	if health > max_health:
		health = max_health
	
	if health <= 0:
		if parent:
		# reparent() particles/sfx
			parent.queue_free()
