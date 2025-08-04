class_name AudioManager extends Node

signal voice_finished()

@onready var music_player : AudioStreamPlayer = $MainMusicPlayer
@onready var voice_player : AudioStreamPlayer = $VoiceLinePlayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and should_escape_to_main_menu():
		LevelTransition.change_scene_to("res://ui/main_menu/main_menu.tscn")


func should_escape_to_main_menu() -> bool:
	var current_scene := get_tree().current_scene
	var scene_file_path := current_scene.scene_file_path
	return (scene_file_path != "res://ui/main_menu/main_menu.tscn" 
		and scene_file_path != "res://ui/boot_splash/boot_splash.tscn")


func start_level_music(level_name: String) -> void:
	if !music_player.playing:
		music_player.play()
	var level_music = str(level_name + "_music")
	self.music_player["parameters/switch_to_clip"] = level_music


func play_vo(line_name: String) -> void:
	if !voice_player.playing:
		voice_player.play()
	self.voice_player["parameters/switch_to_clip"] = line_name
	var audio_stream: AudioStreamInteractive = self.voice_player.stream as AudioStreamInteractive
	var clip_length := 5.0
	for idx in range(audio_stream.clip_count):
		if audio_stream.get_clip_name(idx) == line_name:
			var clip_stream := audio_stream.get_clip_stream(idx)
			clip_length = clip_stream.get_length()
			break
	await get_tree().create_timer(clip_length).timeout
	voice_finished.emit()
