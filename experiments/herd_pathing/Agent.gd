extends KinematicBody2D

var nearby_agent_list : Array = []
var mouse_hover : bool = false

var speed : float = 128
var vel : Vector2 = Vector2()

var navigator : Navigation2D
var target : Vector2 = position setget set_target
var next_pos  : Vector2 = target
var path : PoolVector2Array

var separation_force : Vector2 = Vector2()
var follow_force : Vector2 = Vector2()

func _ready():
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	self.target = position

func _process(delta):
	
	var target_diff : Vector2 = next_pos - position
	
	if target_diff.length() < 16:
		get_next_pos()
		follow_force = Vector2()
	else:
		follow_force = target_diff.normalized() * speed
	
	if len(nearby_agent_list):
		var sum : Vector2 = Vector2()
		for a in nearby_agent_list:
			var diff : Vector2 = position - a.position
			
			if diff.length() != 0:
				sum += Vector2(300 / diff.length(), 0).rotated(diff.angle())
		sum /= nearby_agent_list.size()
		separation_force = sum
	else:
		separation_force = Vector2()
	
	var temp_path = path

	for i in len(path):
		temp_path[i] -= position

	temp_path.insert(0, Vector2())
	$Line2D.points = temp_path

func _physics_process(delta):
	
	var drag : Vector2 = vel * 0.1
	vel += separation_force + follow_force - drag
	
	vel = vel.clamped(speed)
	
	if vel.length() != 0:
		move_and_slide(vel)
	
	if navigator:
		position = navigator.get_closest_point(position)

func set_target(t: Vector2 = target) -> void:
	target = t
	
	path = navigator.get_simple_path(position, target, false)
	get_next_pos()

func get_next_pos() -> void:
	if len(path):
		next_pos = path[0]
		path.remove(0)
		
		
	else:
		next_pos = position

# signal handles

func _on_mouse_entered():
	mouse_hover = true

func _on_mouse_exited():
	mouse_hover = false


func _on_body_entered(body):
	if body.get_script() == get_script() and body.name != name:
		nearby_agent_list.append(body)
		

func _on_body_exited(body):
	if body in nearby_agent_list:
		nearby_agent_list.erase(body)
