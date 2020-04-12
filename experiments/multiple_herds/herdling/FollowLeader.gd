extends "State.gd"

var leader_pos : Vector2
var leader_vel : Vector2

func exit():
	$FollowTimeout.stop()

func process(_delta):
	if controller.herd and controller.herd.leader:
		leader_pos = controller.herd.leader.position
		leader_vel = controller.herd.leader.vel
		
		if controller.herd.leader in controller.local_herdmates:
			if controller.herd.leader.state != "Leading":
				fsm.pop_state()
			if $FollowTimeout.time_left:
				$FollowTimeout.stop()
		elif (leader_pos - controller.position).length() > 1000:
			fsm.push_state("SearchLeader")
		else:
			if $FollowTimeout.is_stopped():
				$FollowTimeout.start()
		
	else:
		# if there is no leader to be found
		# return to previous state
		fsm.pop_state()

func physics_process(_delta):
	var predicted_pos = leader_pos + leader_vel
	
	controller.vel = (predicted_pos - controller.position).normalized()\
			 * controller.speed

func _on_FollowTimeout():
	fsm.push_state("SearchLeader")
