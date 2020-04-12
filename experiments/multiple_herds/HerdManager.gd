extends Node

var herd : Array = []

var target : Vector2 = Vector2() setget set_target
export var navigator_path : NodePath setget set_navigator
onready var navigator : Navigation2D = get_node("../Navigation2D")

var leader = null

func _ready():
	if get_child_count():
		for c in get_children():
			add_herdling(c)
		
		pick_leader()

# herd leader logic
func pick_leader(l : KinematicBody2D = null) -> void:
	if l:
		leader.is_leader = false
		leader = l
	else:
		if leader: 
			leader.is_leader = false
			leader = null
		
		if len(herd):
			leader = herd[randi() % len(herd)]
			leader.is_leader = true

func validate_leader() -> bool:
	return false

# herd navigation logic
func set_target(t : Vector2) -> void:
	target = t

func set_navigator(n):
	var nd = get_node(n)
	
	if nd is Navigation2D:
		navigator = nd
		navigator_path = n

# herd management
func add_herdling(herdling : Node) -> void:
	var par = herdling.get_parent()
	
	if par:
		if par.get_script() == get_script():
			par.remove_herdling(herdling)
		else:
			par.remove_child(herdling)
	
	herd.append(herdling)
	add_child(herdling)
	herdling.herd = self
	herdling.navigator = navigator

func remove_herdling(herdling : Node) -> void:
	if herdling in herd:
		herd.erase(herdling)
	
	if herdling.get_parent() == self:
		remove_child(herdling)
	
	if herdling == leader:
		herdling.is_leader = false
		leader = null
		pick_leader()
	
	herdling.herd = null
