extends BaseButton

@export var skip_first_focus_change := false
@export var volume_db: float = -10.0
@export var focused_sound: AudioStream
@export var presed_sound: AudioStream


func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.focus_entered.connect(_on_focus_entered)
	self.button_down.connect(_on_pressed)


func _on_mouse_entered() -> void:
	grab_focus()


func _on_focus_entered() -> void:
	if skip_first_focus_change:
		skip_first_focus_change = false
		return
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.bus = AudioServer.get_bus_name(BusVolumeControl.Bus.SFX)
	audio_stream_player.stream = focused_sound
	audio_stream_player.volume_db = volume_db
	audio_stream_player.finished.connect(audio_stream_player.queue_free)
	add_child(audio_stream_player)
	audio_stream_player.play()


func _on_pressed() -> void:
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.bus = AudioServer.get_bus_name(BusVolumeControl.Bus.SFX)
	audio_stream_player.stream = presed_sound
	audio_stream_player.volume_db = volume_db
	audio_stream_player.finished.connect(audio_stream_player.queue_free)
	add_child(audio_stream_player)
	audio_stream_player.play()
