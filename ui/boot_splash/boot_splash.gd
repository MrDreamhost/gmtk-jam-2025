extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_video_stream_player_finished() -> void:
	GlobalAudioManager.start_level_music("root")
	LevelTransition.change_scene_to("res://ui/main_menu/main_menu.tscn")
