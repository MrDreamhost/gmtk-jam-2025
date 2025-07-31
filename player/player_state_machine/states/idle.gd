class_name Idle extends State


var player: Player


func _ready() -> void:
	self.player = self.owner


func update_physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("player_jump") and self.player.is_on_floor():
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.JUMP])
		return

	if (
		Input.is_action_just_pressed("player_left")
		or Input.is_action_just_pressed("player_right") 
	):
		self.finished.emit(%PlayerStateMachine.states[PlayerStateMachine.RUN])
