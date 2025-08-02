extends Button

@export var sprite: Sprite2D
@export var texture_regular: CompressedTexture2D
@export var texture_hover: CompressedTexture2D


func _ready() -> void:
	self.sprite.texture = texture_regular

func _on_mouse_entered() -> void:
	self.sprite.texture = texture_hover


func _on_mouse_exited() -> void:
	self.sprite.texture = texture_regular


func _on_button_down() -> void:
	self.sprite.texture = texture_regular
