extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer

var furthest_level: PackedScene = null


func load_with_loading_screen(path: String) -> Resource:
	animation_player.play("fade_in")
	ResourceLoader.load_threaded_request(path)
	await animation_player.animation_finished
	return ResourceLoader.load_threaded_get(path)


func change_scene_to(path: String) -> void:
	animation_player.play("fade_in")
	var scene = await LevelTransition.load_with_loading_screen(path)
	get_tree().change_scene_to_packed(scene)
	play_fade_out()


func play_fade_out() -> void:
	LevelTransition.animation_player.play("fade_out")
