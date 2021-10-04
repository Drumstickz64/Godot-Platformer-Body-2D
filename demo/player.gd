class_name Player
extends PlatformerCharacter2D


func _physics_process(delta: float) -> void:
	var hdirection := _get_hinput()
	
	apply_gravity(delta)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	elif Input.is_action_just_released("jump"):
		cut_jump()
	
	if hdirection == 0:
		apply_friction(delta)
	else:
		apply_movement(delta, hdirection)
	
	velocity = move(delta, true)


func _get_hinput() -> float:
	return sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
