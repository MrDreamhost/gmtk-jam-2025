class_name Idle extends State


var player: Player
var jump_held_time: float = 0.0
var is_jumping: bool = false
var full_jump: float = 1.0
var short_hop: float

func _ready() -> void:
	self.player = self.owner


func update_process(delta: float) -> void:
	if not self.player.animated_sprite_2d.is_playing():
		self.player.animated_sprite_2d.play("idle")

	if Input.is_action_just_pressed("player_jump") and self.player.is_on_floor():
		self.short_hop = self.player.player_config.short_hop_factor
		self.is_jumping = true
		self.jump_held_time = 0.0

	if self.is_jumping:
		self.jump_held_time += delta
		if Input.is_action_just_released("player_jump"):
			self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.JUMP], { "jump_factor": self.short_hop })
			return
		if self.jump_held_time > self.player.player_config.short_hop_window:
			self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.JUMP], { "jump_factor": self.full_jump })
			return

	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		self.player.animated_sprite_2d.flip_h = true if direction < 0 else false
		self.player.animated_sprite_2d.play("idle_to_run")
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.RUN])


func enter(_data := {}) -> void:
	super()
	self.is_jumping = false
