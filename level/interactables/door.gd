@tool
extends Node2D

@export var connected_button: PressurePlate
@export var open_height := 204.0 : set = set_open_height

@export var door_opening_speed: float = 400.0
@export var door_closing_speed: float = 300.0

@onready var animatable_body_2d: AnimatableBody2D = $AnimatableBody2D
@onready var status_circle: Sprite2D = $AnimatableBody2D/StatusCircle
@onready var squash_area_2d: Area2D = $AnimatableBody2D/SquashArea2D

var open_position: Vector2
var opening := false
var reset_flag := false


func _ready() -> void:
	set_open_height(open_height)
	if connected_button is PressurePlate and connected_button.has_signal("button_changed"):
		connected_button.button_changed.connect(on_button_changed)
	else:
		push_warning("door without connected button")


func _physics_process(delta: float) -> void:
	if reset_flag:
		animatable_body_2d.position = Vector2.ZERO
		reset_flag = false
	elif is_squashing_player():
		status_circle.self_modulate = Color.YELLOW
	elif opening:
		var moved_door_position := animatable_body_2d.position.move_toward(open_position, door_opening_speed * delta)
		animatable_body_2d.position = moved_door_position
		status_circle.self_modulate = Color.GREEN
	else: # closing
		var moved_door_position := animatable_body_2d.position.move_toward(Vector2.ZERO, door_closing_speed * delta)
		animatable_body_2d.position = moved_door_position
		status_circle.self_modulate = Color.RED


func is_squashing_player() -> bool:
	for body in squash_area_2d.get_overlapping_bodies():
		if body is Player:
			return true
	return false


func on_button_changed(pressed_down: bool) -> void:
	opening = pressed_down


func _on_button_toggled(toggled_on: bool) -> void:
	on_button_changed(toggled_on)


func set_open_height(_open_height: float) -> void:
	open_height = _open_height
	open_position = Vector2.UP * open_height
	$OpenCollisionShape2D.position = $AnimatableBody2D/CollisionShape2D.position
	$OpenCollisionShape2D.position += open_position


func reset() -> void:
	opening = false
	reset_flag = true
	status_circle.self_modulate = Color.RED
