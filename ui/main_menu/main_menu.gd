extends Control

@onready var main_menu_buttons: VBoxContainer = $MainMenuButtons
@onready var options_panel: PanelContainer = $OptionsPanel
@onready var credits_panel: PanelContainer = $CreditsPanel


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	hide_all_menus()
	main_menu_buttons.visible = true
	%StartButton.grab_focus.call_deferred()


func _on_start_button_pressed() -> void:
	%StartButton.disabled = true
	LevelTransition.change_scene_to("res://game/main.tscn")


func _on_options_button_pressed() -> void:
	hide_all_menus()
	options_panel.visible = true
	get_tree().call_group("start_focus", "grab_focus")


func _on_credits_button_pressed() -> void:
	hide_all_menus()
	credits_panel.visible = true
	get_tree().call_group("start_focus", "grab_focus")


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	hide_all_menus()
	main_menu_buttons.visible = true
	get_tree().call_group("start_focus", "grab_focus")


func hide_all_menus() -> void:
	main_menu_buttons.visible = false
	options_panel.visible = false
	credits_panel.visible = false


func play_slide_in_animation(node: Control) -> void:
	var slide_path_x := get_slide_path_x(node)
	var tween := node.create_tween()
	tween.tween_property(node, "position:x", slide_path_x[0], 0.5) \
			.from(slide_path_x[1]) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func get_slide_path_x(node: Control) -> Vector2:
	var game_width := get_viewport().get_visible_rect().size.x
	var outside_x := game_width - 40.0
	var inside_x := game_width - node.size.x + 40.0
	return Vector2(inside_x, outside_x)
