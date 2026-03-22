@icon("uid://yb2irimddrdm")
extends Node
class_name HealthComponent

@export var parent : Node
@export var max_health : int = 100
@export var health : int = 100

func change_health(amount : int):
	health = clamp(health + amount, 0, max_health)
	#print(health)
	
	if health <= 0:
		# reparent() particles/sfx
		parent.queue_free()
