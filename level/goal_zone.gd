class_name GoalZone
extends Area2D

signal goal_reached(next_level_file: String)

@export_file("*.tscn") var next_level_file


func _ready() -> void:
	assert(self.next_level_file != null, "Unknown next_level_file")
	self.monitoring = false
	# BUG wait 2 physics_frame before activating this goal_zone
	await get_tree().physics_frame
	await get_tree().physics_frame
	self.monitoring = true


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		goal_reached.emit(next_level_file)
