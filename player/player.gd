class_name Player extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -800.0

@onready var hurt_box: HurtBox = $HurtBox
@onready var anim_player : AnimationPlayer = $PlayerAnimationPlayer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	self.hurt_box.hit_received.connect(handle_hit_received)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func handle_respawn_when_dead() -> void:
	if %PlayerStateMachine.states[PlayerStateMachine.DEAD]:
		%PlayerStateMachine.current_state.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.IDLE])


func handle_hit_received(damage: int) -> void:
	print("Got damaged :( for %d DAMAGE" % damage)
	%PlayerStateMachine.current_state.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.DEAD])
