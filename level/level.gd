class_name Level extends Node2D


@export var spawn_point: SpawnPoint

var initial_spawn_position: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(self.spawn_point != null, "No spawn point set in level")
	self.initial_spawn_position = self.spawn_point.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_spawn_point(position: Vector2) -> void:
	self.spawn_point.global_position = position
