class_name Idle extends State


var player: Player


func _ready() -> void:
	self.player = self.owner


func update_process(delta: float) -> void:
	if not self.player.animated_sprite_2d.is_playing():
		self.player.animated_sprite_2d.play("idle")

	if Input.is_action_just_pressed("player_jump") and self.player.is_on_floor():
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.JUMP])
		return

	if (
		Input.is_action_pressed("player_left")
		or Input.is_action_pressed("player_right")
	):
		self.player.animated_sprite_2d.play("idle_to_run")
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.RUN])


func enter(data := {}) -> void:
	super()
