extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func load_with_loading_screen(path: String) -> Resource:
	animation_player.play("fade_in")
	var loaded_resource := ResourceLoader.load(path)
	await animation_player.animation_finished
	return loaded_resource
