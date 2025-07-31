class_name Main extends Node2D


@onready var player_recorder: ReplayRecorder = $PlayerRecorder
@onready var level: Level = $TestLevel
@onready var loop_timer: Timer = $LoopTimer
@onready var label: Label = $CanvasLayer/Label
@onready var player: Player = $Player

var spawned_ghosts: Array[PlayerGhost] = []
var current_loop: int = 1
var changed_spawn: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.respawn_player()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.set_label_text()

	if Input.is_action_just_pressed("set_spawn_point"):
		self.changed_spawn = true
		self.level.set_spawn_point(self.player.global_position)

	if Input.is_action_just_pressed("reset_level"):
		self.reset_level()


func reset_ghosts() -> void:
	for spawned_ghost: PlayerGhost in self.spawned_ghosts:
		spawned_ghost.reset_position()


func respawn_player() -> void:
	self.player.global_position = self.level.spawn_point.global_position


func reset_loop() -> void:
	if self.changed_spawn:
		self.spawn_ghost()
		self.current_loop += 1
		self.changed_spawn = false
	self.respawn_player()
	self.reset_ghosts()


func reset_level() -> void:
	self.loop_timer.stop()
	self.player.global_position = self.level.initial_spawn_position
	self.level.set_spawn_point(self.level.initial_spawn_position)
	for ghost: PlayerGhost in self.spawned_ghosts:
		ghost.queue_free()
	self.spawned_ghosts.clear()
	self.current_loop = 1
	self.player_recorder.reset_replay_data()
	self.loop_timer.start()


func spawn_ghost() -> void:
	var ghost: PlayerGhost = self.player_recorder.spawn_ghost(self.current_loop)
	spawned_ghosts.append(ghost)
	add_child(ghost)
	print("SPAWNED GHOSTS: %s" % self.spawned_ghosts.size())


func set_label_text() -> void:
	self.label.text = "Loop: %d\nTime: %.2f" % [self.current_loop, self.loop_timer.time_left]


func _on_loop_timer_timeout() -> void:
	self.reset_loop()
