extends Control


func _ready() -> void:
	%MasterBusVolumeControl.get_node("VolumeSlider").grab_focus.call_deferred()
	%CrtCheckButton.button_pressed = GlobalAudioManager.crt_enabled


func _on_back_button_pressed() -> void:
	LevelTransition.change_scene_to("res://ui/main_menu/main_menu.tscn")


func _on_crt_check_button_toggled(toggled_on: bool) -> void:
	GlobalAudioManager.crt_enabled = toggled_on
	%CRT.visible = toggled_on
