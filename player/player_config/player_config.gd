class_name PlayerConfig extends Resource


# Run
@export var run_acceleration: float
@export var run_deceleration: float
@export var run_max_speed: float

# Jump
@export var jump_max_height: float
@export var jump_duration: float
## Fall gravity in relation to upwards gravity 2.0 would be fall speed is twice as fast as time to reach max jump height
@export_range(0.1, 10.0, 0.1) var fall_gravity_multiplier: float
@export var air_acceleration: float
## Factor of max jump height 1.0 would be max jump height 0.1 would be 10% of max jump
@export_range(0.1, 1.0, 0.01) var short_hop_factor: float
## Time in seconds before big jump starts
@export var short_hop_window: float
