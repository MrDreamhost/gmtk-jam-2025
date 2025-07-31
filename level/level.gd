class_name Level extends Node2D


@export var spawn_point: SpawnPoint

var initial_spawn: SpawnPoint


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(self.spawn_point != null, "No spawn point set in level")
	self.initial_spawn = self.spawn_point


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
