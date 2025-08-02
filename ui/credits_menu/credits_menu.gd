extends Control


func _on_back_to_menu_button_pressed() -> void:
	LevelTransition.change_scene_to("res://ui/main_menu/main_menu.tscn")
