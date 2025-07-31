extends Node2D

@export var connected_button: PressurePlate
@export var target_position: Vector2
@export var move_duration_sec: float = 1.0
@export var return_delay_sec: float = 3.0

@export var movement_trans : Tween.TransitionType
@export var movement_ease : Tween.EaseType
@export var paused := false : set = set_paused

var original_position: Vector2
var returning := false
var tween : Tween


func _ready() -> void:
	original_position = self.global_position
	on_movement_ended()
	if connected_button:
		connected_button.button_changed.connect(on_button_changed)


func on_movement_ended() -> void:
	tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if movement_trans:
		tween.set_trans(movement_trans)
	if movement_ease:
		tween.set_ease(movement_ease)
	if returning:
		tween.tween_property(self, "global_position", target_position, move_duration_sec).from(original_position)
		tween.tween_callback(on_movement_ended).set_delay(return_delay_sec)
	else:
		tween.tween_property(self, "global_position", original_position, move_duration_sec).from(target_position)
		tween.tween_callback(on_movement_ended).set_delay(return_delay_sec)
	returning = !returning


func on_button_changed(pressed_down: bool) -> void:
	set_paused(not pressed_down)


func set_paused(_paused: bool) -> void:
	paused = _paused
	if paused:
		tween.pause()
	elif not tween.is_running():
		tween.play()
	
