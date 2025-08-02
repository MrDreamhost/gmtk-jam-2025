class_name State extends Node


@warning_ignore("unused_signal")
signal finished(data: Dictionary)


func update_process(_delta: float) -> void:
	pass


func update_physics_process(_delta: float) -> void:
	pass


func enter(_data := {}) -> void:
	print("%s entering state: %s" % [self.owner.name, self.get_script().get_global_name()])


func exit() -> void:
	print("%s exiting state: %s" % [self.owner.name, self.get_script().get_global_name()])
