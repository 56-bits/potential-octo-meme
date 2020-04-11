extends Node

var herd : Array = []

var target : Vector2 = Vector2() setget set_target

var leader = null

func _ready():
	pass

func set_target(t : Vector2) -> void:
	target = t

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

func remove_herdling(herdling : Node) -> void:
	herd.erase(herdling)
	remove_child(herdling)
	herdling.herd = null
