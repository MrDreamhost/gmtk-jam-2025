class_name AudioManager extends Node

@onready var music_player : AudioStreamPlayer = $MainMusicPlayer

var main_volume: int
var music_volume: int
var sfx_volume: int
var voice_volume: int

func _ready() -> void:
	start_level_music(get_tree().root.name)

func start_level_music(level_name: String) -> void:
	if !music_player.playing:
		music_player.play()
	var level_music = str(level_name + "_music")
	self.music_player["parameters/switch_to_clip"] = level_music
