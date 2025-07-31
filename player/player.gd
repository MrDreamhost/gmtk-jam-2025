class_name Player extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var anim_player : AnimationPlayer = $PlayerAnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#Play run animation while running with timescale adjusted for speed
	if velocity.x != 0:
		anim_player.play("run")
		anim_player.speed_scale = get_real_velocity().x/velocity.x
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false

	move_and_slide()
