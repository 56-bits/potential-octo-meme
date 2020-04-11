extends Node

var controller : KinematicBody2D
var fsm : Node

# handle the 
func enter():
	pass

func exit():
	pass

func back():
	fsm.pop_state()
