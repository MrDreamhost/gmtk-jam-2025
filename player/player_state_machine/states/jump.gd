class_name Jump extends State


var player: Player


func _ready() -> void:
	self.player = self.owner


func enter(data := {}) -> void:
	super()
	self.player.velocity.y += Player.JUMP_VELOCITY
	self.finished.emit(%PlayerStateMachine.previous_state)
