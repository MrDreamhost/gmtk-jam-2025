class_name PlayerGhost extends CharacterBody2D


@onready var label: Label = $Sprite2D/Label

var ghost_number: int
var replay_data: ReplayData
var current_index: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(self.replay_data != null, "Ghost has no replay data")
	assert(self.ghost_number != null, "Ghost has no number")
	self.label.text = "Ghost %s" % self.ghost_number


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	if self.current_index < self.replay_data.positions.size():
		self.global_position = self.replay_data.positions[self.current_index]
		self.current_index += 1
