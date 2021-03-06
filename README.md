# Base PlatformerBody2D for Godot

A simple base platformer body 2D with acceleration, deceleration, jumping, and jump-cutting. acceleration and jump trajectories calculated using simple time and max-distance/max-speed values exported to the editor.

_Note: this node is designed with typical up and down directions in mind. which means gravity will always point vertical and movement will always be to the horizontal. so no standing on walls or going around planets. You can however, reverse gravity by setting `gravity_scale` to a negative number._

## API

### Export Variables

- `stop_on_slope`
- `max_floor_angle`
- `run_max_speed`
- `run_time_to_max_speed`
- `run_time_to_stop`
- `run_time_to_stop_air`
- `jump_max_height`
- `jump_cut_height`
- `jump_time_to_peak`
- `jump_time_to_fall`
- `fall_max_speed`
- `snap_vector_length`

### Properties

- `move_direction`
- `velocity`
- `gravity_scale`

### Jumping and Gravity

- `jump()` method
- `cut_jump()` method

gravity is automatically applied to the body.

PlatformerBody2D uses `move_and_slide_with_snap()` to move.the snap vector is calculated using the down_direction and snap_vector_length.

### acceleration and deceleration

acceleration and deceleration are automatically applied to the character when you set the move direction using `set_move_direction()` to a value thats not zero. `set_move_direction()` will clamp the value between -1 and 1.

#### `should_accelerate()` and `should_decelerate()`

Acceleration and deceleration are automatically applied if their respective methods return true. you override these methods to change when they're applied.

### `get_*()` methods

when a value is determined using branched logic, like how to deceleration is either `run_friction` or `run_drag` depending on if the character is on the ground or in the air. Then it is provided using a `get_*()` method. you can override these methods to add extra branching logic. Like making the deceleration 0 if the player is holding down the slide button.

```gdscript
func get_deceleration() -> float:
	return 0.0 if Input.is_action_pressed('slide') else .get_deceleration()
```

### `is_*()` methods

This script provides a few `is_*()` methods to check if the body is in a curtain state. like running or falling.
