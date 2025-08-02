class_name AudioManager extends Node

@onready var music_player : AudioStreamPlayer = $MainMusicPlayer

var main_volume: int
var music_volume: int
var sfx_volume: int
var voice_volume: int

func start_level_music(level: Level) -> void:
	if !music_player.playing:
		music_player.play()
	var level_string = level.name
	var level_music = str(level_string + "_music")
	self.music_player["parameters/switch_to_clip"] = level_music
