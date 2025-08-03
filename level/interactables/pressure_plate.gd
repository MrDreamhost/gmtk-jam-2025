class_name PressurePlate extends Area2D

signal button_changed(pressed_down: bool)

## Time (in seconds) before the button automatically returns to its "up" (unpressed) state.
## Set to 0.0 for a button that stays pressed indefinitely.
@export var auto_reset_delay_sec := 0.0

@onready var reset_delay_timer: Timer = $ResetDelayTimer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var press_in_audio_stream_player: AudioStreamPlayer = $PressInAudioStreamPlayer
@onready var press_out_audio_stream_player: AudioStreamPlayer = $PressOutAudioStreamPlayer

var button_pressed := false : set = set_button_pressed


func _on_body_entered(body: Node2D) -> void:
	if can_press_button(body):
		reset_delay_timer.stop()
		button_pressed = true


func _on_body_exited(body: Node2D) -> void:
	if not get_overlapping_bodies().any(can_press_button):
		if is_zero_approx(auto_reset_delay_sec):
			button_pressed = false
		else:
			reset_delay_timer.start(auto_reset_delay_sec)


func _on_delayed_button_timer_timeout() -> void:
	button_pressed = false


func can_press_button(body: Node2D) -> bool:
	return body is Player or body is PlayerGhost


func set_button_pressed(_button_pressed: bool) -> void:
	var changed := button_pressed != _button_pressed
	button_pressed = _button_pressed
	if changed and is_node_ready() and is_inside_tree():
		button_changed.emit(button_pressed)
		if button_pressed:
			animated_sprite_2d.play("default")
			press_in_audio_stream_player.play()
		else:
			animated_sprite_2d.play_backwards("default")
			press_out_audio_stream_player.play()


func reset() -> void:
	self.button_pressed = false
	self.animated_sprite_2d.stop()
