class_name PlatformerCharacter2D
extends KinematicBody2D


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

# run variables
onready var run_acceleration := run_max_speed / run_time_to_max_speed
onready var run_friction := run_max_speed / run_time_to_stop
onready var run_drag := run_max_speed / run_time_to_stop_air
# jump variables
onready var jump_initial_velocity := (2*jump_max_height / jump_time_to_peak) * -1
onready var jump_min_velocity := (2*jump_cut_height / jump_time_to_peak) * -1
onready var gravity_jump := 2*jump_max_height / pow(jump_time_to_peak, 2)
onready var gravity_fall := 2*jump_max_height / pow(jump_time_to_fall, 2)

var velocity := Vector2.ZERO
var gravity := gravity_fall


func jump() -> void:
	velocity.y = jump_initial_velocity


func cut_jump() -> void:
	if velocity.y <= jump_min_velocity:
		velocity.y = jump_min_velocity


func _apply_gravity(delta: float) -> void:
	gravity = gravity_jump if velocity.y < 0.0 else gravity_fall
	velocity.y += gravity * delta


func _apply_friction(delta: float) -> void:
	var deceleration := run_friction if is_on_floor() else run_drag
	velocity = velocity.move_toward(Vector2(0.0, velocity.y), deceleration * delta)


func _apply_movement(delta: float, hdirection: float) -> void:
	var new_velocity_x := velocity.x + (run_acceleration * hdirection * delta)
	velocity.x = clamp(new_velocity_x, -run_max_speed, run_max_speed)


func _get_velocity_verlet(delta) -> Vector2:
	# simplified velocity verlet used because acceleration is (semi) constant.
	# equation is: velocity * delta + 1/2acceleration * delta^2
	# a delta is extracted from both sides of the addition operation
	# because its applied in move_and_slide
	var previous_velocity := velocity
	var acceleration := velocity - previous_velocity
	return velocity + acceleration * 0.5 * delta
