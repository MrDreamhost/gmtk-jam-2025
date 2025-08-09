extends Control


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%StartButton.grab_focus.call_deferred()
	ResourceLoader.load_threaded_request.call_deferred("res://game/main.tscn")


func _on_start_button_pressed() -> void:
	%StartButton.disabled = true
	LevelTransition.change_scene_to("res://game/main.tscn")


func _on_options_button_pressed() -> void:
	LevelTransition.change_scene_to("res://ui/options_menu/options_menu.tscn")


func _on_credits_button_pressed() -> void:
	LevelTransition.change_scene_to("res://ui/credits_menu/credits_menu.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
