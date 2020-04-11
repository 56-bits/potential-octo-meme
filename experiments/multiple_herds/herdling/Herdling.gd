extends KinematicBody2D

# the intention is to use a state machine

func _ready():
	pass

func _process(delta):
	$StateMachine.process(delta)

func _physics_process(delta):
	$StateMachine.physics_process(delta)
