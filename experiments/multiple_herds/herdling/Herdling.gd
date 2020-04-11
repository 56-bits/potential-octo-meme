extends KinematicBody2D

var herd : Node
var is_leader : bool = false

var mouse_hover : bool = false
var info_lock : bool = false

func _ready():
	pass


# the intention is to use a state machine
func _process(delta):
	$StateMachine.process(delta)
	
	if mouse_hover or info_lock:
		update_info()

func _physics_process(delta):
	$StateMachine.physics_process(delta)

#info stuffs
func _unhandled_input(event):
	if mouse_hover and event.is_action_released("secondary_click"):
		info_lock = !info_lock

func update_info() -> void:
	var r = $RichTextLabel
	
	r.clear()
	r.push_align(RichTextLabel.ALIGN_CENTER)
	
	r.push_bold()
	r.add_text("State: ")
	r.pop()
	r.add_text($StateMachine.state.name)
	
	if is_leader:
		r.newline()
		r.push_bold()
		r.add_text("Is Leader")
		r.pop()
	
	r.pop()

func _on_mouse_entered():
	mouse_hover = true
	$RichTextLabel.show()

func _on_mouse_exited():
	mouse_hover = false
	$RichTextLabel.visible = info_lock
