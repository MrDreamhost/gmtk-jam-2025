class_name Main extends Node2D

@export var inital_level: PackedScene

@onready var player_recorder: ReplayRecorder = $PlayerRecorder
@onready var loop_timer: Timer = $LoopTimer
@onready var label: Label = $CanvasLayer/Label
@onready var player: Player = $Player

var current_level: Level
var spawned_ghosts: Array[PlayerGhost] = []
var current_loop: int = 1
var changed_spawn: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.load_level(self.inital_level.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.set_label_text()

	if Input.is_action_just_pressed("set_spawn_point"):
		self.changed_spawn = true
		self.current_level.set_spawn_point(self.player.global_position)

	if Input.is_action_just_pressed("reset_level"):
		self.reset_level()


func reset_ghosts() -> void:
	for spawned_ghost: PlayerGhost in self.spawned_ghosts:
		spawned_ghost.reset_position()


func respawn_player() -> void:
	self.player.global_position = self.current_level.spawn_point.global_position
	self.player.velocity = Vector2(0,0)


func reset_loop() -> void:
	if self.changed_spawn:
		self.spawn_ghost()
		self.current_loop += 1
		self.changed_spawn = false
	self.player_recorder.reset_replay_data()
	self.respawn_player()
	self.reset_ghosts()


func reset_level() -> void:
	self.loop_timer.stop()
	self.player.global_position = self.current_level.initial_spawn_position
	self.current_level.set_spawn_point(self.current_level.initial_spawn_position)
	for ghost: PlayerGhost in self.spawned_ghosts:
		ghost.queue_free()
	self.spawned_ghosts.clear()
	self.current_loop = 1
	self.player_recorder.reset_replay_data()
	self.loop_timer.start()


func spawn_ghost() -> void:
	if spawned_ghosts.size() >= 1:
		var ghost: PlayerGhost = spawned_ghosts[0]
		ghost.replay_data = self.player_recorder.replay_data
	else:
		var ghost: PlayerGhost = self.player_recorder.spawn_ghost(self.current_loop)
		spawned_ghosts.append(ghost)
		add_child(ghost)
	print("SPAWNED GHOSTS: %s" % self.spawned_ghosts.size())


func set_label_text() -> void:
	self.label.text = "Loop: %d\nTime: %.2f" % [self.current_loop, self.loop_timer.time_left]


func load_level(level: Level) -> void:
	self.current_level = level
	self.add_child(self.current_level)
	self.reset_level()
	for goal_zone: GoalZone in get_tree().get_nodes_in_group("goal_zone"):
		if not goal_zone.goal_reached.is_connected(_on_goal_rached):
			goal_zone.goal_reached.connect(_on_goal_rached)



func _on_loop_timer_timeout() -> void:
	self.reset_loop()


func _on_goal_rached(next_level_file: String) -> void:
	var next_level_scene := await LevelTransition.load_with_loading_screen(next_level_file) as PackedScene
	if current_level:
		current_level.queue_free()
	var next_level := next_level_scene.instantiate() as Level
	load_level(next_level)
	LevelTransition.play_fade_out()
	await LevelTransition.animation_player.animation_finished
