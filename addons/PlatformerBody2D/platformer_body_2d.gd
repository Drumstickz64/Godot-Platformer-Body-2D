class_name PlatformerBody2D
extends KinematicBody2D


const INFINITE_INIRTIA = false
const MAX_SLIDES := 4


export var stop_on_slope := false
export(float, 0.0, 180.0) var max_floor_angle := 45.0
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
export var snap_vector_length := 8.0

# run variables
onready var run_acceleration := run_max_speed / run_time_to_max_speed
onready var run_friction := run_max_speed / run_time_to_stop
onready var run_drag := run_max_speed / run_time_to_stop_air
# jump variables
onready var jump_initial_velocity := (2*jump_max_height / jump_time_to_peak) * -1
onready var jump_min_velocity := (2*jump_cut_height / jump_time_to_peak) * -1
onready var gravity_jump := 2*jump_max_height / pow(jump_time_to_peak, 2)
onready var gravity_fall := 2*jump_max_height / pow(jump_time_to_fall, 2)
onready var snap := get_snap()
onready var floor_max_angle := deg2rad(max_floor_angle)

var gravity_scale := 1.0
var velocity := Vector2.ZERO
var move_direction := 0.0
var _previous_velocity := Vector2.ZERO
var _wants_to_jump := false


func _physics_process(delta: float) -> void:
	snap = get_snap()
	
	if _wants_to_jump and is_jumping():
		_wants_to_jump = false
	
	apply_gravity(delta)
	
	if should_accelerate():
		apply_acceleration(delta)
	
	if should_decelerate():
		apply_deceleration(delta)
	
	# simplified velocity verlet used because acceleration is (semi) constant.
	# equation is: velocity * delta + 1/2acceleration * delta^2
	# a delta is extracted from both sides of the addition operation
	# because its applied in move_and_slide
	var acceleration := velocity - _previous_velocity
	_previous_velocity = velocity
	var velocity_verlet := velocity + acceleration * 0.5 * delta
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP,
			stop_on_slope, MAX_SLIDES, floor_max_angle, INFINITE_INIRTIA)


func jump() -> void:
	velocity.y = jump_initial_velocity
	_wants_to_jump = true


func cut_jump() -> void:
	if velocity.y <= jump_min_velocity:
		velocity.y = jump_min_velocity


func get_snap() -> Vector2:
	return Vector2.DOWN * snap_vector_length if not _wants_to_jump else Vector2.ZERO


func apply_gravity(delta: float) -> void:
	get_gravity()
	velocity.y += get_gravity() * gravity_scale * delta
	velocity.y = clamp(velocity.y, -fall_max_speed, fall_max_speed)


func get_gravity() -> float:
	return gravity_jump if is_jumping() else gravity_fall


func set_move_direction(direction: float) -> void:
	move_direction = clamp(direction, -1.0, 1.0)


func apply_deceleration(delta: float) -> void:
	var deceleration := get_deceleration()
	velocity.x = move_toward(velocity.x, 0, deceleration * delta)


func should_decelerate() -> bool:
	return not is_equal_approx(move_direction, clamp(velocity.x, -1.0, 1.0))


func get_deceleration() -> float:
	return run_friction if is_on_floor() else run_drag


func apply_acceleration(delta: float) -> void:
	velocity.x = move_toward(velocity.x, run_max_speed * move_direction, get_acceleration() * delta)


func should_accelerate() -> bool:
	return not is_zero_approx(move_direction)


func get_acceleration() -> float:
	return run_acceleration


func is_idle() -> bool:
	return is_on_floor() and is_zero_approx(move_direction)


func is_running() -> bool:
	return is_on_floor() and not is_zero_approx(move_direction)


func is_jumping() -> bool:
	return not is_on_floor() and velocity.y < 0.0


func is_falling() -> bool:
	return not is_on_floor() and velocity.y >= 0.0
