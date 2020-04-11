extends KinematicBody2D

var target_pos : Vector2 = Vector2(0,0)
var path : PoolVector2Array
var next_pos : Vector2

var speed : float = 200

func _ready():
	pass

func _input(event : InputEvent):
	if event.is_action_pressed("primary_click"):
		var m_pos : Vector2 = get_global_mouse_position()
		target_pos = m_pos
		($"../Target" as Position2D).global_position = m_pos
		
		#get the generted path
		path = ($"../Navigation2D" as Navigation2D).get_simple_path(position, target_pos, false)
		get_next_pos()

func _process(delta):
	
	# if no next pos is defined, or if its close enough
	# then move on to the next point in the queue
	
	if not next_pos or (position - next_pos).length() < 16:
		get_next_pos()
		

func _physics_process(delta):
	if not next_pos: #check if there is a next pos
		return
	
	var mov : Vector2 = (next_pos - position).normalized() * speed
	move_and_slide(mov)

# the general flow should be that this function is called
# to start going to the next point when the last one is 
# reached
func get_next_pos() -> void:
		
	if path:
		next_pos = path[0]
		path.remove(0)
	else:
		next_pos = position
