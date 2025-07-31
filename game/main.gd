class_name Main extends Node2D


@onready var player_recorder: ReplayRecorder = $PlayerRecorder

var spawned_ghosts: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_ghost"):
		self.spawned_ghosts += 1
		var ghost: PlayerGhost = self.player_recorder.spawn_ghost(self.spawned_ghosts)
		add_child(ghost)
		print("SPAWNED GHOSTS: %s" % self.spawned_ghosts)
