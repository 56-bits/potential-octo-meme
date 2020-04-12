extends "State.gd"

var path : PoolVector2Array
var next_point : Vector2

var initial_delay : float = 10
var delay : float = initial_delay

func enter():
	delay = initial_delay
	calculate_path()
	$SearchTimeout.start(delay)

func exit():
	$SearchTimeout.stop()
	clear_path()

func process(_delta):
	
	if next_point:
		var next_point_diff : Vector2 = next_point - controller.position
		
		if next_point_diff.length() < 8:
			get_next_point()
	
	if controller.herd and controller.herd.leader:
		if controller.herd.leader in controller.local_herdmates:
			fsm.pop_state()
		
		for h in controller.local_herdmates:
			if h.state == "FollowHerd":
				fsm.pop_state()
				break
	else:
		fsm.pop_state()
	
	if controller.mouse_hover or controller.info_lock:
		var temp_path = path
	
		for i in len(path):
			temp_path[i] -= controller.position
	
		temp_path.insert(0, Vector2())
		controller.get_node("Line2D").points = temp_path

func physics_process(_delta):
	controller.vel = (next_point - controller.position).normalized()\
			* controller.speed

func get_next_point():
	if len(path):
		next_point = path[0]
		path.remove(0)
	else:
		next_point = controller.position

func calculate_path():
	clear_path()
	
	if controller.navigator and controller.herd and controller.herd.leader:
		var n : Navigation2D = controller.navigator
		path = n.get_simple_path(
			controller.position,
			controller.herd.leader.position, 
			false
		)
	else:
		fsm.pop_state()
	
	get_next_point()

func _on_SearchTimeout():
	calculate_path()
	
	if delay > 2: delay -= 1
	$SearchTimeout.start(delay)

func clear_path():
	for i in len(path):
		path.remove(0)
