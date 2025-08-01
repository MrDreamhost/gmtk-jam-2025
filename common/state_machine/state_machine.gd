class_name StateMachine extends Node


@export var initial_state: State = null

var current_state: State = null
var previous_state: State = null
var states: Array[State]


func _ready() -> void:
	await self.owner.ready
	assert(not self.states.is_empty(), "%s: No states specified" % self.name)
	assert(self.initial_state != null, "%s: No initial state specified" % self.name)
	for state: State in self.states:
		state.finished.connect(self.switch_state)

	self.current_state = self.initial_state
	self.current_state.enter()


func _process(delta: float) -> void:
	self.current_state.update_process(delta)


func _physics_process(delta: float) -> void:
	self.current_state.update_physics_process(delta)


func switch_state(target_state: State, data: Dictionary = {}) -> void:
	self.previous_state = self.current_state
	self.current_state = target_state
	self.previous_state.exit()
	self.current_state.enter(data)
