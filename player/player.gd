class_name Player extends CharacterBody2D


@export var player_config: PlayerConfig = preload("res://player/player_config/player_config.tres")

@onready var hurt_box: HurtBox = $HurtBox
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var sfx_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var coyote_timer: float = 0.0


func _ready() -> void:
	player_config.reset_state()
	self.hurt_box.hit_received.connect(handle_hit_received)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and %PlayerStateMachine.current_state != %PlayerStateMachine.states[%PlayerStateMachine.JUMP]:
		velocity += Vector2.DOWN * %PlayerStateMachine/Jump.gravity_down * delta

	move_and_slide()


func handle_respawn_when_dead() -> void:
	if %PlayerStateMachine.states[PlayerStateMachine.DEAD]:
		%PlayerStateMachine.current_state.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.IDLE])


func handle_hit_received(damage: int) -> void:
	print("Got damaged :( for %d DAMAGE" % damage)
	%PlayerStateMachine.current_state.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.DEAD])


func update_coyote_timer(delta: float):
	if self.is_on_floor():
		self.coyote_timer = self.player_config.coyote_time
	else:
		self.coyote_timer -= delta


func play_sound(sound_name: String) -> void:
	if !self.sfx_player.playing:
		self.sfx_player.play()
	self.sfx_player["parameters/switch_to_clip"] = sound_name
