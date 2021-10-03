class_name Player
extends PlatformerCharacter2D


func _physics_process(delta: float) -> void:
	var hdirection := _get_hinput()
	
	_apply_gravity(delta)
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		jump()
	elif Input.is_action_just_released("ui_up"):
		cut_jump()
	
	if hdirection == 0:
		_apply_friction(delta)
	else:
		_apply_movement(delta, hdirection)
	
	var velocity_verlet := _get_velocity_verlet(delta)
	velocity = move_and_slide(velocity_verlet, Vector2.UP, true)


func _get_hinput() -> float:
	return sign(Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
