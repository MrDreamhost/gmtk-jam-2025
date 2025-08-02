class_name Dead extends State


var player: Player


func _ready() -> void:
	self.player = self.owner


func update_physics_process(_delta: float) -> void:
	self.player.velocity = Vector2.ZERO

func enter(_data := {}) -> void:
	super()
	self.player.play_sound("dead")
	self.player.died.emit()
