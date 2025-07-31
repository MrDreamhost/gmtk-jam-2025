class_name HitBox extends Area2D


@export var damage: int


func _ready() -> void:
	assert(self.damage != null, "HitBox damage isn't set")
