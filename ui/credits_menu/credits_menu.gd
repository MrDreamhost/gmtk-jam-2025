extends Control

@onready var contribution_text_box: RichTextLabel = %ContributionTextBox
@onready var back_button: TextureButton = %BackButton


func _ready() -> void:
	randomize_contribution_order()
	back_button.grab_focus.call_deferred()


func randomize_contribution_order() -> void:
	var lines := contribution_text_box.text.split("\n", false)
	var new_lines: Array[String] = []
	new_lines.append_array(lines)
	new_lines.shuffle()
	contribution_text_box.text = new_lines.reduce(func(text, line): 
		return text + "\n" + line, "")


func _on_back_to_menu_button_pressed() -> void:
	back_button.disabled = true
	LevelTransition.change_scene_to("res://ui/main_menu/main_menu.tscn")
