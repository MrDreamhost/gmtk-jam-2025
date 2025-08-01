@tool
extends StaticBody2D

const TILE_TEXTURE_SIZE := Vector2i(102, 118)

@export var width_in_pixel := TILE_TEXTURE_SIZE.x : set = set_width_in_pixel
@export var width_in_tile := 1 : get = get_width_in_tiles, set = set_width_in_tiles

@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@export var texture: Texture2D: set = set_texture


func _ready() -> void:
	resize_platform()


func resize_platform() -> void:
	if not is_node_ready():
		return
	line_2d.set_point_position(1, Vector2(width_in_pixel, 0.0))
	collision_shape_2d.position.x = width_in_pixel / 2.0
	var rect_shape: RectangleShape2D = collision_shape_2d.shape
	rect_shape.size.x = width_in_pixel


func get_width_in_tiles() -> int:
	return width_in_pixel / TILE_TEXTURE_SIZE.x


func set_width_in_tiles(tile_count: int) -> void:
	set_width_in_pixel(tile_count * TILE_TEXTURE_SIZE.x)


func set_width_in_pixel(_width_in_pixel: int) -> void:
	width_in_pixel = _width_in_pixel
	resize_platform()

func set_texture(value: Texture2D) -> void:
	texture = value
	$Line2D.texture = value
