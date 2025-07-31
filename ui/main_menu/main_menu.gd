extends Control


func _on_start_button_pressed() -> void:
	LevelTransition.change_scene_to("res://game/main.tscn")


func _on_how_to_play_button_pressed() -> void:
	pass # Replace with function body.


func _on_options_button_pressed() -> void:
	LevelTransition.change_scene_to("res://ui/options_menu/options_menu.tscn")


func _on_credits_button_pressed() -> void:
	LevelTransition.change_scene_to("res://ui/credits_menu/credits_menu.tscn")
