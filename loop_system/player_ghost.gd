class_name PlayerGhost extends AnimatableBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


var ghost_number: int
var replay_data: ReplayData
var current_index: int = 0
var current_animation: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(self.replay_data != null, "Ghost has no replay data")
	assert(self.ghost_number != null, "Ghost has no number")
	#self.label.text = "Ghost %s" % self.ghost_number


func _physics_process(_delta: float) -> void:
	if self.current_index < self.replay_data.frames.size():
		var frame = self.replay_data.frames[current_index]
		self.global_position = frame.get("position")
		if self.animated_sprite_2d.animation != frame.get("animation"):
			self.animated_sprite_2d.play(frame.get("animation"))
		self.animated_sprite_2d.flip_h = frame.get("animation_flip_h")
		self.current_index += 1


func reset_position() -> void:
	self.current_index = 0
