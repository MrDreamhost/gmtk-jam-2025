extends Control

@onready var contribution_text_box: RichTextLabel = %ContributionTextBox
@onready var back_button: TextureButton = %BackButton


func _ready() -> void:
	randomize_contribution_order()
	back_button.grab_focus.call_deferred()


func randomize_contribution_order() -> void:
	var new_lines := ""
	var lines := contribution_text_box.text.split("\n", false)
	for line in lines:
		randi() % lines.size()


func _on_back_to_menu_button_pressed() -> void:
	LevelTransition.change_scene_to("res://ui/main_menu/main_menu.tscn")
