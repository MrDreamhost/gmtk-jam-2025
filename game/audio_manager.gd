class_name AudioManager extends Node

@onready var music_player : AudioStreamPlayer = $MainMusicPlayer
@onready var voice_player : AudioStreamPlayer = $VoiceLinePlayer

func _ready() -> void:
	start_level_music(get_tree().root.name)

func start_level_music(level_name: String) -> void:
	if !music_player.playing:
		music_player.play()
	var level_music = str(level_name + "_music")
	self.music_player["parameters/switch_to_clip"] = level_music

func play_vo(line_name: String) -> void:
	if line_name == "any":
		var line_array: Array[String] = ["Level01","Level02","Level03","Level04","Level05","Level06","Level07","Level08","Level09"]
		line_name = line_array.pick_random()
	if !voice_player.playing:
		voice_player.play()
	self.voice_player["parameters/switch_to_clip"] = line_name
