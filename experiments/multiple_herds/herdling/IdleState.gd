extends "State.gd"

var speed : float = 100
var vel : Vector2 = Vector2()

func physics_process(delta):
	
	vel += Vector2(rand_range(-5, 5) ,rand_range(-5, 5))
	vel = vel.clamped(speed)
	
	if vel.length():
		var rem : Vector2 = controller.move_and_slide(vel)
