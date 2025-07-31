class_name ReplayRecorder extends Node


@export var player: Player

var replay_data: ReplayData
var ghost_scene: PackedScene = preload("res://loop_system/player_ghost.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(self.player != null, "Player hasn't been set")
	self.reset_replay_data()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	self.replay_data.positions.append(self.player.global_position)


func spawn_ghost(number: int) -> PlayerGhost:
	print("Spawning ghost")
	var ghost: PlayerGhost = self.ghost_scene.instantiate()
	ghost.ghost_number = number
	ghost.replay_data = self.replay_data
	self.reset_replay_data()
	return ghost


func reset_replay_data() -> void:
	self.replay_data = ReplayData.new()
