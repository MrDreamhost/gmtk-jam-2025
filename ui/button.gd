extends TextureButton

@export var sprite: Sprite2D
@export var texture_regular: CompressedTexture2D

@onready var sfx_hover: AudioStreamPlayer = $HoverAudioStreamPlayer
@onready var sfx_select: AudioStreamPlayer = $SelectAudioStreamPlayer
@onready var focus_border_color_rect: ColorRect = $FocusBorderColorRect


func _ready() -> void:
	focus_border_color_rect.visible = has_focus()


func _on_button_down() -> void:
	#self.sfx_select.play()
	pass


func _on_focus_entered() -> void:
	#focus_border_color_rect.visible = true
	#self.sfx_hover.play()
	pass


func _on_focus_exited() -> void:
	#focus_border_color_rect.visible = false
	pass
