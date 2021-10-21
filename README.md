# Base PlatformerBody2D for Godot

A simple base platformer body 2D with acceleration, deceleration, jumping, and jump-cutting. acceleration and jump trajectories calculated using simple time and max-distance/max-speed values exported to the editor.

## Functions

- **Move:** Move the character.
- **Jump:** perform a jump.
- **cut_jump:** cut the jump short.
- **apply_gravity:** apply gravity.
- **apply_acceleration** accelerate in a given direction.
- **apply_deceleration:** slowly decelerate.
- **get_acceleration:** allows for adding different types of acceleration.
- **get_deceleration:** allows for adding different types of deceleration.
- **get_gravity:** allows for adding different types of gravity.

## Properties

- **up_direction**
- **down_direction**
