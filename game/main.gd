class_name Main extends Node2D


@onready var player_recorder: ReplayRecorder = $PlayerRecorder
@onready var level: Level = $TestLevel
@onready var loop_timer: Timer = $LoopTimer
@onready var label: Label = $CanvasLayer/Label
@onready var player: Player = $Player

var spawned_ghosts: Array[PlayerGhost] = []
var current_loop: int = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.player.global_position = self.level.spawn_point.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.set_label_text()
	if Input.is_action_just_pressed("spawn_ghost"):
		var ghost_number: int  = self.spawned_ghosts.size() + 1
		var ghost: PlayerGhost = self.player_recorder.spawn_ghost(ghost_number)
		spawned_ghosts.append(ghost)
		add_child(ghost)
		print("SPAWNED GHOSTS: %s" % self.spawned_ghosts.size())

	if Input.is_action_just_pressed("reset_ghosts"):
		self.reset_ghosts()


func reset_ghosts() -> void:
	for spawned_ghost: PlayerGhost in self.spawned_ghosts:
		spawned_ghost.reset_position()


func set_label_text() -> void:
	self.label.text = "Loop: %d\nTime: %.2f" % [self.current_loop, self.loop_timer.time_left]


func _on_loop_timer_timeout() -> void:
	self.current_loop += 1
