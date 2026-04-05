extends CharacterBody3D

# OPT Maybe break this down into multiple components and also try making a state machine
# TODO for camera maybe multiple cameras in this scene and set current or other solution
# For camera kinda intrested in trying and learning how to make a minimap aswell efficient
signal step

func _emit_steps_with_anim():
	emit_signal("step")

@export var SPEED := 4.0
@export var DEADZONE = 0.0

const BASE_SPEED := 4.0

var current_anim_speed := 1.0

func _physics_process(_delta: float) -> void:
	#%DustParticles.amount_ratio = velocity.length() / 8
	var input_direction := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var input_strength := input_direction.length()
	if velocity.length() < 0.1:
		#print("I am standing still")
		current_anim_speed = lerpf(current_anim_speed, 1.0, 10 * _delta)
		#%AnimationTree.currentAnim = %AnimationTree.IDLE
	else:
		#print("I am moving")
		var target_speed = (SPEED / 4.0)
		current_anim_speed = lerpf(current_anim_speed, target_speed, 10 * _delta)
		#%AnimationTree.currentAnim = %AnimationTree.WALK
	#%AnimationTree["parameters/TimeScale/scale"] = current_anim_speed

	if input_strength > DEADZONE:
		input_direction = input_direction.normalized() 
		var speed_multiplier := input_strength
		#var movement_direction := (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
		var movement_direction := (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).rotated(Vector3.UP, deg_to_rad(45)).normalized()

		velocity.x = movement_direction.x * SPEED * speed_multiplier
		velocity.z = movement_direction.z * SPEED * speed_multiplier
		
		# TODO rotation stuff above some animation stuff and bellow some pausing stuff
		$MeshInstance3D.look_at(position - movement_direction)#.rotated(Vector3.UP, deg_to_rad(45)))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

# OPT This shouldnt be handled on player script
#func _unhandled_input(event: InputEvent) -> void:
	#if Global.input == true:
		#if event.is_action_pressed("ui_cancel"):
			#if $PauseMenu.visible == false:
				#$PauseMenu.show()
				#$PauseMenu.pause()
