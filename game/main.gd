class_name Main extends Node2D

@export var inital_level: PackedScene
@export var shockwave_offset := Vector2.ZERO

@onready var player_recorder: ReplayRecorder = $PlayerRecorder
@onready var loop_timer: Timer = $LoopTimer
@onready var label: Label = $CanvasLayer/Label
@onready var player: Player = $Player

@onready var player_dummy: Node2D = $PlayerDummy
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shockwave_mat: ShaderMaterial = $CanvasLayer/ShockwaveOverlay.material
@onready var victory_player: Node2D = $VictoryPlayer

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
	self.player.handle_respawn_when_dead()


func reset_loop() -> void:
	if self.changed_spawn:
		self.spawn_ghost()
		self.current_loop += 1
		self.changed_spawn = false
	self.player_recorder.reset_replay_data()
	self.respawn_player()
	self.reset_ghosts()
	self.loop_timer.start()
	get_tree().paused = false


func reset_level() -> void:
	self.loop_timer.stop()
	self.current_level.set_spawn_point(self.current_level.initial_spawn_position)
	for ghost: PlayerGhost in self.spawned_ghosts:
		ghost.queue_free()
	self.spawned_ghosts.clear()
	self.current_loop = 1
	self.player_recorder.reset_replay_data()
	self.respawn_player()
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
	var current_spawn := self.current_level.spawn_point
	current_spawn.loop_timer = loop_timer
	self.reset_level()
	for goal_zone: GoalZone in get_tree().get_nodes_in_group("goal_zone"):
		if not goal_zone.goal_reached.is_connected(_on_goal_rached):
			goal_zone.goal_reached.connect(_on_goal_rached)



func _on_loop_timer_timeout() -> void:
	trigger_shockwave()
	get_tree().paused = true
	var loop_ended_animation := animation_player.get_animation("loop_ended")
	var current_spawn: SpawnPoint = self.current_level.spawn_point
	player_dummy.global_position = player.global_position
	for child in player_dummy.get_children():
		player_dummy.remove_child(child)
		child.queue_free()
	player_dummy.add_child(player.animated_sprite_2d.duplicate())
	loop_ended_animation.track_set_key_value(3, 0, player.global_position)
	loop_ended_animation.track_set_key_value(3, 1, current_spawn.global_position)
	animation_player.play("loop_ended")


func turn_clock_back() -> void:
	current_level.spawn_point.reversed = true


func _on_goal_rached(next_level_file: String) -> void:
	remove_child(player)
	var goal_zone: GoalZone = get_tree().get_first_node_in_group("goal_zone")
	goal_zone.visible = false
	loop_timer.stop()
	
	victory_player.global_position = player.global_position
	victory_player.visible = true
	var animation_player: AnimationPlayer = victory_player.get_node("AnimationPlayer")
	var animation := animation_player.get_animation("victory_eat")
	animation.track_set_key_value(0, 0, victory_player.to_local(goal_zone.global_position))
	animation_player.play("victory_eat")
	await animation_player.animation_finished
	$VictoryPlayer.visible = false
	
	var next_level_scene := await LevelTransition.load_with_loading_screen(next_level_file) as PackedScene
	add_child(player)
	if current_level:
		current_level.queue_free()
	var next_level := next_level_scene.instantiate() as Level
	load_level(next_level)
	LevelTransition.play_fade_out()
	await LevelTransition.animation_player.animation_finished



func trigger_shockwave():
	var spawn: SpawnPoint = current_level.spawn_point
	var viewport := spawn.get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	var spawn_center := spawn.global_position
	spawn_center += shockwave_offset
	var uv_pos = spawn_center / Vector2(viewport_size)
	shockwave_mat.set_shader_parameter("center", uv_pos)


func _on_h_slider_value_changed(value: float) -> void:
	shockwave_mat.set_shader_parameter("radius", value)
