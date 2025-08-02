class_name Jump extends State


var player: Player
var jump_velocity: float
var time_to_apex: float
var gravity_up: float
var gravity_down: float
var short_hop: bool

func _ready() -> void:
	self.player = self.owner


func update_physics_process(delta: float) -> void:
	if not self.short_hop and self.player.velocity.y < 0 and Input.is_action_just_released("player_jump"):
		self.player.velocity.y = 0

	if self.player.velocity.y < 0:
		self.player.velocity.y += self.gravity_up * delta
	else:
		self.player.velocity.y += self.gravity_down * delta



	if self.player.is_on_floor():
		if not self.is_horizontal_input_pressed():
			self.player.velocity.x = 0
			self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.IDLE])
		else:
			self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.RUN])
		return

	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		self.player.velocity.x = move_toward(
			self.player.velocity.x,
			direction * self.player.player_config.run_max_speed,
			self.player.player_config.air_acceleration * delta
		)
		self.player.animated_sprite_2d.flip_h = true if direction < 0 else false
	else:
		self.player.velocity.x = move_toward(
			self.player.velocity.x,
			0,
			self.player.player_config.air_acceleration * delta
		)


func enter(data := {}) -> void:
	super()
	var jump_factor = data.get("jump_factor")
	self.short_hop = true if jump_factor != 1.0 else false
	self.calculate_jump()
	self.player.animated_sprite_2d.play("jump")
	self.player.velocity.y = -self.jump_velocity * sqrt(jump_factor)
	self.player.animated_sprite_2d.position = Vector2(112, -112)


func exit() -> void:
	super()
	self.player.animated_sprite_2d.stop()
	self.player.animated_sprite_2d.position = Vector2(96, -98)


func is_horizontal_input_pressed() -> bool:
	return (
		Input.is_action_pressed("player_left")
		or Input.is_action_pressed("player_right")
	)


func calculate_jump() -> void:
	# Calculate jump base equation: h = (1/2) * g * (t/2)^2
	self.time_to_apex = self.player.player_config.jump_duration / 2
	self.gravity_up = (
		(2 * self.player.player_config.jump_max_height) / (pow(time_to_apex, 2))
	)
	self.gravity_down = self.gravity_up * self.player.player_config.fall_gravity_multiplier
	self.jump_velocity = self.gravity_up * time_to_apex
