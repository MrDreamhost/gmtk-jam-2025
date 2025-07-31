class_name Dead extends State


var player: Player


func _ready() -> void:
	self.player = self.owner


func update_physics_process(delta: float) -> void:
	self.player.velocity = Vector2.ZERO
