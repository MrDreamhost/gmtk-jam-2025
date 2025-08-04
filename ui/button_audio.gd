extends Node

@export var skip_first_focus_change := true

@onready var focused_audio_player: AudioStreamPlayer = $FocusedAudioPlayer
@onready var pressed_audio_player: AudioStreamPlayer = $PressedAudioPlayer


func _ready() -> void:
	get_viewport().gui_focus_changed.connect(_on_gui_focus_changed)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var focuse_owner := get_viewport().gui_get_focus_owner()
		if should_play_audio_for(focuse_owner):
			pressed_audio_player.play()


func _on_gui_focus_changed(node: Control) -> void:
	if skip_first_focus_change:
		skip_first_focus_change = false
	elif should_play_audio_for(node):
		focused_audio_player.play()


func should_play_audio_for(node: Control) -> bool:
	return node is BaseButton
