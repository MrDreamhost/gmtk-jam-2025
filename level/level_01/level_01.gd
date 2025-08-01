extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)


func _on_audio_stream_player_finished() -> void:
	$AudioStreamPlayer.play()
