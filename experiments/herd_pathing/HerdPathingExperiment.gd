extends Node2D

var agent_pk = preload("Agent.tscn")
var agents : Array = []

func _ready():
	for i in range(200):
		var agent = agent_pk.instance()
		agents.append(agent)
		add_child(agent)
		agent.navigator = $Navigation2D
		agent.position = Vector2(1000, 600) + Vector2(randf() * 1800 - 900, randf() * 1000 - 500)
		

func _input(event):
	if event.is_action_pressed("primary_click"):
		var pos = get_local_mouse_position()
		$Target.position = pos
		
		for i in agents:
			i.target = pos
