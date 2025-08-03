extends Control


@onready var main_menu_scene: PackedScene = load("res://ui/main_menu/main_menu.tscn")


func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)
