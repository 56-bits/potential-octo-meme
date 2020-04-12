extends KinematicBody2D

var herd : Node
var is_leader : bool = false

var mouse_hover : bool = false
var info_lock : bool = false

var navigator : Navigation2D

var local_herdmates : Array = []

var speed : float = 100
var vel : Vector2 = Vector2(rand_range(-100, 100), rand_range(-100, 100))

var state : String

func _ready():
	pass


# the intention is to use a state machine
func _process(delta):
	$StateMachine.process(delta)
	
	if mouse_hover or info_lock:
		update_info()

func _physics_process(delta):
	$StateMachine.physics_process(delta)
	
	if vel.length():
		vel = vel.clamped(speed)
		vel = move_and_slide(vel)


#info stuffs
func _unhandled_input(event):
	# lock the information panel on a right click
	if mouse_hover and event.is_action_released("secondary_click"):
		info_lock = !info_lock

func update_info() -> void:
	var r = $RichTextLabel
	
	r.clear()
	r.push_align(RichTextLabel.ALIGN_CENTER)
	
	r.push_bold()
	r.add_text("Name: ")
	r.pop()
	r.add_text(name)
	
	if herd:
		r.newline()
		r.push_bold()
		r.add_text("Herd: ")
		r.pop()
		r.add_text(herd.name)
	
	r.newline()
	r.push_bold()
	r.add_text("State: ")
	r.pop()
	r.add_text(state)
	
	if is_leader:
		r.newline()
		r.push_bold()
		r.add_text("Is Leader")
		r.pop()
	
	r.pop()

func _on_mouse_entered():
	mouse_hover = true
	$RichTextLabel.show()
	$Line2D.show()

func _on_mouse_exited():
	mouse_hover = false
	$RichTextLabel.visible = info_lock
	$Line2D.visible = info_lock


#local herdlings
func _on_LocalArea_body_entered(body):
	if body.herd == herd:
		local_herdmates.append(body)

func _on_LocalArea_body_exited(body):
	if body in local_herdmates:
		local_herdmates.erase(body)
