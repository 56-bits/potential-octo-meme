extends "State.gd"

# this state is a simple flock simulatio 
# and random walk

# exit conditions are:
# - too far from herd centroid -> search leader

var separation : Vector2 = Vector2()
var steer : Vector2 = Vector2()
var cohesion : Vector2 = Vector2()

func enter():
	controller.speed = 50

func exit():
	controller.speed = 200

func process(_delta):
	var num_herdmates = len(controller.local_herdmates)
	if num_herdmates:
		separation = Vector2()
		steer = Vector2()
		cohesion = Vector2()
		
		for h in controller.local_herdmates:
			cohesion += h.position - controller.position
			steer += h.vel
			
			var separation_diff : Vector2 = controller.position - h.position
			
			if separation_diff.length() < 48:
				separation_diff = separation_diff.normalized() *\
						(960 / (separation_diff.length()/48 + 1))
				separation += separation_diff
		
		separation /= num_herdmates
		steer /= num_herdmates
		cohesion /= num_herdmates
		
		if controller.herd and controller.herd.leader:
			if (controller.position - controller.herd.leader.position).length() > 300:
				fsm.push_state("FollowLeader")
#			cohesion = (cohesion + controller.herd.leader.position/4) /1.25

func physics_process(delta):
	var drag = controller.vel * 0.1
	controller.vel += (separation + steer + cohesion - drag) * delta
	controller.vel += Vector2(rand_range(-50, 50) ,rand_range(-50, 50)) * delta

