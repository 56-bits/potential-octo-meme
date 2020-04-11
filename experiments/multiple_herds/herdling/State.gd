extends Node

var controller : KinematicBody2D
var fsm : Node

# handle the 
func enter():
	pass

func exit(next_state):
	pass

func back():
	fsm.pop_state()
