extends Button

@export var sprite: Sprite2D
@export var texture_regular: CompressedTexture2D
@export var texture_hover: CompressedTexture2D

@onready var sfx_hover: AudioStreamPlayer = $AudioStreamPlayer
@onready var sfx_select: AudioStreamPlayer = $AudioStreamPlayer2

func _ready() -> void:
	self.sprite.texture = texture_regular

func _on_mouse_entered() -> void:
	self.sprite.texture = texture_hover
	self.sfx_hover.play()

func _on_mouse_exited() -> void:
	self.sprite.texture = texture_regular

func _on_button_down() -> void:
	self.sprite.texture = texture_regular
	self.sfx_select.play()
