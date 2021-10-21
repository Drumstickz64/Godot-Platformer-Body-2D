class_name PlatformerBody2D
extends KinematicBody2D


var up_direction := Vector2.UP
var down_direction := Vector2.DOWN setget _set_down_direction

# run export variables
export var run_max_speed := 280.0
export var run_time_to_max_speed := 0.1
export var run_time_to_stop := 0.05
export var run_time_to_stop_air := 0.15
# jump export variables
export var jump_max_height := 120.0
export var jump_cut_height := 40.0
export var jump_time_to_peak := 0.5
export var jump_time_to_fall := 0.4
export var fall_max_speed := 600.0
export var snap_vector_length := 0.0 setget _set_snap_vector_length

# run variables
onready var run_acceleration := run_max_speed / run_time_to_max_speed
onready var run_friction := run_max_speed / run_time_to_stop
onready var run_drag := run_max_speed / run_time_to_stop_air
# jump variables
onready var jump_initial_velocity := (2*jump_max_height / jump_time_to_peak) * -1
onready var jump_min_velocity := (2*jump_cut_height / jump_time_to_peak) * -1
onready var gravity_jump := 2*jump_max_height / pow(jump_time_to_peak, 2)
onready var gravity_fall := 2*jump_max_height / pow(jump_time_to_fall, 2)
onready var snap := _get_new_snap()

var velocity := Vector2.ZERO
var gravity := gravity_fall
var _is_jumping := false


func move(
	delta: float,
	stop_on_slope := false,
	max_slides := 4,
	floor_max_angle := 0.785398,
	infinite_inertia := true
) -> Vector2:
	if _is_jumping and is_on_floor() and velocity.y >= 0:
		_on_land()
	
	# simplified velocity verlet used because acceleration is (semi) constant.
	# equation is: velocity * delta + 1/2acceleration * delta^2
	# a delta is extracted from both sides of the addition operation
	# because its applied in move_and_slide
	var previous_velocity := velocity
	var acceleration := velocity - previous_velocity
	var velocity_verlet := velocity + acceleration * 0.5 * delta
	
	return move_and_slide_with_snap(velocity, snap, up_direction,
			stop_on_slope, max_slides, floor_max_angle, infinite_inertia)


func jump() -> void:
	velocity.y = jump_initial_velocity
	_is_jumping = true
	snap = Vector2.ZERO


func cut_jump() -> void:
	if velocity.y <= jump_min_velocity:
		velocity.y = jump_min_velocity


func apply_gravity(delta: float) -> void:
	gravity = get_gravity()
	velocity.y = move_toward(velocity.y, fall_max_speed, gravity * delta)


func get_gravity() -> float:
	return gravity_jump if velocity.y < 0.0 else gravity_fall


func apply_deceleration(delta: float) -> void:
	var deceleration := get_deceleration()
	velocity.x = move_toward(velocity.x, 0, deceleration * delta)


func should_decelerate(hdirection: float) -> bool:
	return hdirection != sign(velocity.x)


func get_deceleration() -> float:
	return run_friction if is_on_floor() else run_drag


func apply_acceleration(delta: float, hdirection: float) -> void:
	velocity.x = move_toward(velocity.x, run_max_speed * hdirection, get_acceleration() * delta)


func should_accelerate(hdirection: float) -> bool:
	return hdirection != 0


func get_acceleration() -> float:
	return run_acceleration


func _on_land() -> void:
	_is_jumping = false
	snap = _get_new_snap()


func _get_new_snap() -> Vector2:
	return down_direction * snap_vector_length


func _set_snap_vector_length(value: float) -> void:
	snap_vector_length = value
	snap = _get_new_snap()


func _set_down_direction(value: Vector2) -> void:
	down_direction = value
	snap = _get_new_snap()
