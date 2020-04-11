extends Node

var fsm : Node

# handle the 
func enter():
	pass

func exit(next_state):
	pass

func back():
	fsm.pop_state()
