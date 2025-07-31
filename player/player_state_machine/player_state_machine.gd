class_name PlayerStateMachine extends StateMachine


enum { IDLE, RUN, JUMP, DEAD }

@onready var idle: Idle = $Idle
@onready var run: Run = $Run
@onready var jump: Jump = $Jump
@onready var dead: Dead = $Dead


func _ready() -> void:
	self.states = [
		self.idle,
		self.run,
		self.jump,
		self.dead,
	]
	super()
