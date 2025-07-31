@tool
extends StaticBody2D

@export var tile_texture: Texture2D : set = set_tile_texture
@export var width_in_pixel := 102 : set = set_width_in_pixel
@export var width_in_tile := 1 : get = get_width_in_tiles, set = set_width_in_tiles

@onready var line_2d: Line2D = $Line2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	set_tile_texture(tile_texture)


func resize_platform() -> void:
	line_2d.width = tile_texture.get_size().y
	line_2d.set_point_position(1, Vector2(width_in_pixel, 0.0))
	collision_shape_2d.position.x = width_in_pixel / 2.0
	var rect_shape: RectangleShape2D = collision_shape_2d.shape
	rect_shape.size.x = width_in_pixel


func get_width_in_tiles() -> int:
	return width_in_pixel / tile_texture.get_size().x


func set_width_in_tiles(tile_count: int) -> void:
	set_width_in_pixel(tile_count * tile_texture.get_size().x)


func set_width_in_pixel(_width_in_pixel: int) -> void:
	width_in_pixel = _width_in_pixel
	resize_platform()


func set_tile_texture(_tile_texture: Texture2D) -> void:
	tile_texture = _tile_texture
	line_2d.texture = tile_texture
	resize_platform()
