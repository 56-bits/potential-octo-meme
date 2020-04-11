extends "State.gd"

# based on https://gdscript.com/godot-state-machine (11-4-2020)

signal state_changed

var state : Node
var state_stack : Array = []

func _ready():
	change_state(get_child(0))

func change_state(new_state):
	state.exit()
	state = get_node(new_state)
	_enter_state()

func push_state(new_state):
	state_stack.push_front(state)
	change_state(new_state)

func pop_state():
	var s = state_stack.pop_front()
	if s:
		change_state(s)
	else:
		change_state(get_child(0))

func _enter_state():
	state.fsm = self
	state.enter()


# Forward game functions
func process(delta):
	if state.has_method("process"):
		state.process(delta)

func physics_process(delta):
	if state.has_method("physics_process"):
		state.physics_process(delta)
