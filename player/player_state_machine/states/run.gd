class_name Run extends State


var player: Player


func _ready() -> void:
	self.player = self.owner


func update_process(delta: float) -> void:
	if not self.player.animated_sprite_2d.is_playing():
		self.player.animated_sprite_2d.play("run")


func update_physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("player_jump") and self.player.is_on_floor():
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.JUMP])
		return

	if not (
		Input.is_action_pressed("player_left")
		or Input.is_action_pressed("player_right")
	):
		self.player.animated_sprite_2d.play("run_to_idle")
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.IDLE])
		return

	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		self.player.velocity.x = direction * Player.SPEED
	else:
		self.player.velocity.x = move_toward(self.player.velocity.x, 0, Player.SPEED)

	self.player.animated_sprite_2d.flip_h = true if direction < 0 else false


func enter(data := {}) -> void:
	super()


func exit() -> void:
	self.player.velocity.x = 0
