class_name Main extends Node2D

const VICTORY_PLAYER = preload("res://player/victory_player.tscn")

@export var inital_level: PackedScene
@export var shockwave_offset := Vector2.ZERO

@onready var player_recorder: ReplayRecorder = $PlayerRecorder
@onready var loop_timer: Timer = $LoopTimer
@onready var play_timer: Timer = $PlayTimer
@onready var label: Label = $CanvasLayer/Label
@onready var player: Player = $Player
@onready var player_dummy: Node2D = $PlayerDummy
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var shockwave_mat: ShaderMaterial = %ShockwaveOverlay.material
@onready var animated_timer: AnimatedSprite2D = $CanvasLayer/AnimatedTimer
@onready var level_complete_panel: LevelCompletePanel = $CanvasLayer/LevelCompletePanel
@onready var level_record_repository: LevelRecordRepository = $LevelRecordRepository

var current_level: Level
var next_level_file: String
var spawned_ghosts: Array[PlayerGhost] = []
var changed_spawn: bool = false
var level_record := LevelRecordRepository.LevelRecord.new()
var animated_timer_tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not LevelTransition.furthest_level == null:
		self.inital_level = LevelTransition.furthest_level
	self.load_level(self.inital_level.instantiate())
	self.level_complete_panel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.set_label_text()

	if Input.is_action_just_pressed("set_spawn_point"):
		self.changed_spawn = true
		self.current_level.spawn_point.sprite_2d.stop()
		self.current_level.spawn_point.sprite_2d.play("spawner_placement")
		self.current_level.set_spawn_point(self.player.global_position)
		self.player.play_sound("place")

	if Input.is_action_just_pressed("reset_level"):
		self.reset_level()


func reset_ghosts() -> void:
	for spawned_ghost: PlayerGhost in self.spawned_ghosts:
		spawned_ghost.reset_position()


func respawn_player() -> void:
	self.player.global_position = self.current_level.spawn_point.global_position
	self.player.velocity = Vector2.ZERO
	self.player.animated_sprite_2d.play("idle")
	self.player.coyote_timer = 0.0
	self.player.handle_respawn_when_dead()


func reset_loop() -> void:
	if self.changed_spawn:
		self.spawn_ghost()
		self.level_record.loop_count += 1
		self.changed_spawn = false
	self.player_recorder.reset_replay_data()
	self.respawn_player()
	self.reset_ghosts()
	reset_timer_no_music()
	get_tree().paused = false


func reset_level() -> void:
	self.loop_timer.stop()
	self.animated_timer.stop()
	# reset level here
	get_tree().call_group("resettable", "reset")
	self.current_level.set_spawn_point(self.current_level.initial_spawn_position)
	for ghost: PlayerGhost in self.spawned_ghosts:
		ghost.queue_free()
	self.spawned_ghosts.clear()
	self.level_record.loop_count = 1
	self.level_record.total_reset_count += 1
	level_record.total_time += play_timer.wait_time - play_timer.time_left
	self.play_timer.start()
	self.player_recorder.reset_replay_data()
	self.respawn_player()
	reset_timer_and_music()


func spawn_ghost() -> void:
	if spawned_ghosts.size() >= 1:
		var ghost: PlayerGhost = spawned_ghosts[0]
		ghost.replay_data = self.player_recorder.replay_data
	else:
		var loop_idx := self.level_record.loop_count
		var ghost: PlayerGhost = self.player_recorder.spawn_ghost(loop_idx)
		spawned_ghosts.append(ghost)
		add_child(ghost)
	print("SPAWNED GHOSTS: %s" % self.spawned_ghosts.size())


func set_label_text() -> void:
	self.label.text = "Loop: %d\nTime: %.2f" % [self.level_record.loop_count, self.loop_timer.time_left]


func load_level(level: Level) -> void:
	self.current_level = level
	self.animated_timer.visible = true
	self.add_child(self.current_level)
	var current_spawn := self.current_level.spawn_point
	current_spawn.loop_timer = loop_timer
	self.reset_level()
	
	self.level_record = LevelRecordRepository.LevelRecord.new()
	self.level_record.level_file = level.scene_file_path
	for goal_zone: GoalZone in get_tree().get_nodes_in_group("goal_zone"):
		if not goal_zone.goal_reached.is_connected(_on_goal_reached):
			goal_zone.goal_reached.connect(_on_goal_reached)


func _on_loop_timer_timeout() -> void:
	# BUG get_tree().paused = true doesnt work on web export, frezzes game
	#get_tree().paused = true
	var loop_ended_animation := animation_player.get_animation("loop_ended")
	var current_spawn: SpawnPoint = self.current_level.spawn_point
	player_dummy.global_position = player.global_position
	for child in player_dummy.get_children():
		child.queue_free()
	player_dummy.add_child(player.animated_sprite_2d.duplicate())
	loop_ended_animation.track_set_key_value(3, 0, player.global_position)
	loop_ended_animation.track_set_key_value(3, 1, current_spawn.global_position)
	set_shockwave_center_to_spawn_point()
	animation_player.play("loop_ended")


func set_shockwave_center_to_spawn_point() -> void:
	var spawn: SpawnPoint = current_level.spawn_point
	var viewport := spawn.get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	var spawn_center := spawn.global_position
	spawn_center += shockwave_offset
	var uv_pos = spawn_center / Vector2(viewport_size)
	shockwave_mat.set_shader_parameter("center", uv_pos)


func turn_clock_back() -> void:
	current_level.spawn_point.reversed = true


func _on_goal_reached(_next_level_file: String) -> void:
	next_level_file = _next_level_file
	call_deferred("play_victory_eat_apple_animation")
	loop_timer.stop()
	self.animated_timer.stop()
	self.animated_timer.visible = false
	
	level_record.time = play_timer.wait_time - play_timer.time_left
	level_record.total_time += level_record.time
	play_timer.stop()
	var best_level_record := level_record_repository.add_record_and_return_total(level_record)
	
	var data := LevelCompletePanel.Data.new()
	data.time = level_record.time
	data.loop_count = level_record.loop_count
	data.fastes_time = best_level_record.time
	data.death_count = best_level_record.total_death_count
	data.reset_count = best_level_record.total_reset_count
	var dev_record: LevelRecordRepository.LevelRecord = level_record_repository.dev_records.get(level_record.level_file)
	if dev_record != null:
		data.dev_record_time = dev_record.time
	else:
		data.dev_record_time = 4_000.0
	
	level_complete_panel.set_data(data)
	level_complete_panel.play_slide_in_from_side_animation(player.global_position)



func play_victory_eat_apple_animation() -> void:
	GlobalAudioManager.start_level_music("victory")
	create_tween().tween_callback(func():
		GlobalAudioManager.play_vo(current_level.name)).set_delay(1.5)
	
	var goal_zone: GoalZone = get_tree().get_first_node_in_group("goal_zone")
	goal_zone.queue_free()
	remove_child(player)
	
	var victory_player: RigidBody2D = VICTORY_PLAYER.instantiate()
	victory_player.global_position = player.global_position
	var victory_animation_player: AnimationPlayer = victory_player.get_node("AnimationPlayer")
	var animation := victory_animation_player.get_animation("victory_eat")
	animation.track_set_key_value(0, 0, victory_player.to_local(goal_zone.global_position))
	current_level.add_child(victory_player)
	victory_player.apply_central_impulse(player.velocity)
	var animated_player_sprite: AnimatedSprite2D = victory_player.get_node("AnimatedSprite2D")
	GlobalAudioManager.voice_finished.connect( \
			on_voic_finished.bind(animated_player_sprite), CONNECT_ONE_SHOT)


func on_voic_finished(animated_player_sprite: AnimatedSprite2D):
	animated_player_sprite.play("eat_loop")


func transition_to_next_level(level_file: String) -> void:
	var next_level_scene := await LevelTransition.load_with_loading_screen(level_file) as PackedScene
	LevelTransition.furthest_level = next_level_scene
	add_child(player)
	current_level.queue_free()
	var next_level := next_level_scene.instantiate() as Level
	load_level(next_level)
	LevelTransition.play_fade_out()


func reset_timer_and_music() -> void:
	self.loop_timer.start()
	self.animated_timer.play("timer")
	GlobalAudioManager.start_level_music(current_level.name)


func reset_timer_no_music() -> void:
	self.loop_timer.start()
	self.animated_timer.play("timer")


func start_timer_reset_animation() -> void:
	self.animated_timer.play("timer_reset")


func _on_level_complete_panel_next_level() -> void:
	transition_to_next_level(next_level_file)


func _on_level_complete_panel_retry_level() -> void:
	transition_to_next_level(current_level.scene_file_path)


func _on_player_died() -> void:
	level_record.total_death_count += 1


func _on_animated_timer_area_body_entered(body: Node2D) -> void:
	if body is Player:
		if self.animated_timer_tween:
			self.animated_timer_tween.kill()
		self.animated_timer_tween = create_tween()
		self.animated_timer_tween.tween_property(self.animated_timer, "modulate:a", 0.5, 0.2)


func _on_animated_timer_area_body_exited(body: Node2D) -> void:
	if body is Player:
		if self.animated_timer_tween:
			self.animated_timer_tween.kill()
		self.animated_timer_tween = create_tween()
		self.animated_timer_tween.tween_property(self.animated_timer, "modulate:a", 1.0, 0.2)
