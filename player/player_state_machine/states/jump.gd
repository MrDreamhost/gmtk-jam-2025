class_name Jump extends State


var player: Player


func _ready() -> void:
	self.player = self.owner


func update_physics_process(delta: float) -> void:
	if self.player.is_on_floor():
		if not self.is_horizontal_input_pressed():
			self.player.velocity.x = 0
			self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.IDLE])
		else:
			self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.RUN])
		return

	if not self.is_horizontal_input_pressed():
		self.player.velocity.x = 0
		return

	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		self.player.velocity.x = direction * Player.SPEED
	else:
		self.player.velocity.x = move_toward(self.player.velocity.x, 0, Player.SPEED)

	self.player.animated_sprite_2d.flip_h = true if direction < 0 else false


func enter(data := {}) -> void:
	super()
	self.player.animated_sprite_2d.play("jump")
	self.player.velocity.y += Player.JUMP_VELOCITY


func exit() -> void:
	super()
	self.player.animated_sprite_2d.stop()


func is_horizontal_input_pressed() -> bool:
	return (
		Input.is_action_pressed("player_left")
		or Input.is_action_pressed("player_right")
	)
