class_name BusVolumeControl extends Container

enum Bus { 
	MASTER = 0, MUSIC = 1, SFX = 2, VOICE = 3,
}

@export var bus: Bus = Bus.MASTER
@export var test_audio: AudioStream
@export var skip_first_focus_change := false

@onready var focus_line_2d: Line2D = %FocusLine2D
@onready var label: Label = %Label
@onready var volume_slider: HSlider = $VolumeSlider
@onready var test_audio_player: AudioStreamPlayer = $TestAudioStreamPlayer


func _ready():
	var bus_name := AudioServer.get_bus_name(bus)
	label.text = "%s Volume:" % bus_name
	test_audio_player.bus = bus_name
	test_audio_player.stream = test_audio
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	volume_slider.value_changed.connect(_on_volume_slider_value_changed)
	focus_line_2d.visible = has_focus()
	var font_color := theme.get_color("font_color", "Button")
	label.add_theme_color_override("font_color", font_color)


func _on_volume_slider_value_changed(value: float):
	var muted := value <= volume_slider.min_value
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, muted)
	if is_node_ready() and not test_audio_player.playing:
		test_audio_player.play()


func _on_volume_slider_focus_entered() -> void:
	focus_line_2d.visible = true
	var font_hover_color := theme.get_color("font_hover_color", "Button")
	label.add_theme_color_override("font_color", font_hover_color)
	if skip_first_focus_change:
		skip_first_focus_change = false
	elif not Engine.is_editor_hint():
		test_audio_player.play()


func _on_volume_slider_focus_exited() -> void:
	focus_line_2d.visible = false
	var font_color := theme.get_color("font_color", "Button")
	label.add_theme_color_override("font_color", font_color)


func _on_volume_slider_mouse_entered() -> void:
	volume_slider.grab_focus()
