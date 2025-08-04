@tool
extends Container

enum Bus { 
	MASTER = 0, MUSIC = 1, SFX = 2, VOICE = 3,
}

@export var bus: Bus = Bus.MASTER
@export var test_audio: AudioStream

@onready var volume_slider: HSlider = $VolumeSlider
@onready var test_audio_player: AudioStreamPlayer = $TestAudioStreamPlayer
 

# Called when the node enters the scene tree for the first time.
func _ready():
	var bus_name := AudioServer.get_bus_name(bus)
	$Label.text = "%s Volume:" % bus_name
	test_audio_player.bus = bus_name
	test_audio_player.stream = test_audio
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	volume_slider.value_changed.connect(_on_volume_slider_value_changed)


func _on_volume_slider_value_changed(value: float):
	var muted := value <= volume_slider.min_value
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, muted)
	if is_node_ready() and not test_audio_player.playing:
		test_audio_player.play()
