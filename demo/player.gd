class_name Player
extends PlatformerBody2D


func _physics_process(_delta: float) -> void:
	set_move_direction(_get_hinput())
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	elif Input.is_action_just_released("jump"):
		cut_jump()


# overriding get_deceleration to provide new deceleration
func get_deceleration() -> float:
	return 0.0 if Input.is_action_pressed("slide") else .get_deceleration()


func _get_hinput() -> float:
	return sign(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
