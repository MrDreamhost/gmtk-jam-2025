class_name PlayerConfig extends Resource


# Run
@export var run_acceleration: float
@export var run_deceleration: float
@export var run_max_speed: float

# Jump
@export var jump_max_height: float
@export var jump_duration: float
## Fall gravity in relation to upwards gravity 2.0 would be fall speed is twice as fast as time to reach max jump height
@export_range(0.1, 10.0, 0.1) var fall_gravity_multiplier: float = 0.1
@export var air_acceleration: float
## Multiplier while releasing jump key during ascent
@export_range(1.0, 10.0, 0.1) var jump_cutoff: float = 1.0
## Allow jump for short time after falling off a ledge
@export_range(0.0, 1.0, 0.01) var coyote_time: float
