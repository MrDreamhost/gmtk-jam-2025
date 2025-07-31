class_name HurtBox extends Area2D


signal hit_received(damage: int)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("area_entered", _on_area_entered)


func _on_area_entered(hitbox: Area2D) -> void:
	if hitbox is not HitBox:
		return
	
	self.hit_received.emit(hitbox.damage)
