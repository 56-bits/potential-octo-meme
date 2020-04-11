extends Camera2D

class_name MoveCamera2D

export var zoom_rate = 10
export var speed = 400

func _ready():
	current = true

func _process(delta):
	if Input.is_action_pressed("camera_up"):
		position.y -= speed * delta * zoom.y
	if Input.is_action_pressed("camera_down"):
		position.y += speed * delta * zoom.y
	if Input.is_action_pressed("camera_left"):
		position.x -= speed * delta * zoom.x
	if Input.is_action_pressed("camera_right"):
		position.x += speed * delta * zoom.x
	
	if Input.is_action_just_released("camera_zoom_out"):
		zoom *= 1 + zoom_rate * delta
	if Input.is_action_just_released("camera_zoom_in"):
		zoom /= 1 + zoom_rate * delta
