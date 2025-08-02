@tool
extends Container


@export var bus: Bus = Bus.MASTER
@export var test_audio: AudioStream

@onready var volume_slider = $VolumeSlider as HSlider

enum Bus {
	MASTER=0, MUSIC=1, SFX=2, VOICE=3
}


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = AudioServer.get_bus_name(bus) + " Volume:"
	$MutedCheckButton.button_pressed = AudioServer.is_bus_mute(bus)
	$AudioStreamPlayer.stream = test_audio
	$AudioStreamPlayer.bus = AudioServer.get_bus_name(bus)
	
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus))


func _on_muted_check_button_toggled(toggled_on: bool):
	AudioServer.set_bus_mute(bus, toggled_on)


func _on_volume_slider_value_changed(value: float):
	var muted = value <= volume_slider.min_value
	$MutedCheckButton.button_pressed = muted
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	AudioServer.set_bus_mute(bus, muted)
	if(not $AudioStreamPlayer.playing):
		$AudioStreamPlayer.play()


func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	if bus == Bus.VOICE:
		GlobalAudioManager.play_vo("any")
