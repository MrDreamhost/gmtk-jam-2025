class_name Run extends State


var player: Player


func _ready() -> void:
	self.player = self.owner


func update_physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("player_jump") and self.player.is_on_floor():
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.JUMP])
		return

	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		var acceleration = self.player.player_config.run_acceleration
		if is_turning(direction):
			acceleration += self.player.player_config.run_deceleration
			if self.player.animated_sprite_2d.animation != "turn_ground":
				self.player.animated_sprite_2d.play("turn_ground")

		if not self.player.animated_sprite_2d.is_playing():
			self.player.animated_sprite_2d.flip_h = true if direction < 0 else false
			self.player.animated_sprite_2d.play("run")

		self.player.velocity.x = move_toward(
			self.player.velocity.x,
			direction * self.player.player_config.run_max_speed,
			acceleration * delta
		)
		return
	else:
		self.player.velocity.x = move_toward(
			self.player.velocity.x,
			0,
			self.player.player_config.run_deceleration * delta
		)
	
	if not (
		Input.is_action_pressed("player_left")
		or Input.is_action_pressed("player_right")
	) and self.player.velocity.x == 0:
		if self.player.animated_sprite_2d.animation == "turn_ground" and self.player.animated_sprite_2d.frame >= 2:
			self.player.animated_sprite_2d.flip_h = not self.player.animated_sprite_2d.flip_h
		self.player.animated_sprite_2d.play("run_to_idle")
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.IDLE])
		return


func enter(_data := {}) -> void:
	super()


func is_turning(direction: float) -> bool:
	return true if signf(self.player.velocity.x * direction) < 0 else false
