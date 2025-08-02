class_name SpawnPoint extends Node2D


@export var loop_timer: Timer

@onready var timer_progress_bar: TextureProgressBar = %TimerProgressBar
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

var reversed := false


func _ready() -> void:
	timer_progress_bar.value = 0.0


func _process(delta: float) -> void: 
	if reversed:
		timer_progress_bar.value -= delta * timer_progress_bar.max_value * 2.0
		reversed = timer_progress_bar.value > 0.0
	elif loop_timer != null and loop_timer.time_left > 0.0:
		timer_progress_bar.value = 1.0 - (loop_timer.time_left / loop_timer.wait_time)


func _on_sprite_2d_animation_finished() -> void:
	self.sprite_2d.play("loop_spawner")
