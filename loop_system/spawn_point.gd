class_name SpawnPoint extends Node2D


@export var loop_timer: Timer

@onready var timer_progress_bar: TextureProgressBar = %TimerProgressBar
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D


func _ready() -> void:
	timer_progress_bar.value = 0.0


func _process(_delta: float) -> void:
	if loop_timer != null and loop_timer.time_left > 0.0:
		timer_progress_bar.value = 1.0 - (loop_timer.time_left / loop_timer.wait_time)
