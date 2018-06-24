extends Node2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dragging = false
export (float) var DRAGFACTOR

func _ready():
	#set_process_input(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if Input.is_action_pressed("right_click"):
		dragging = true
	else:
		dragging = false
	#elif Input.event
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func _input(event):
#	if event is InputEventMouseButton:
#		print(event)
#		if event.is_pressed():
#			print(event)
#			dragging = true
#		else:
#			dragging = false
	if event is InputEventMouseMotion and dragging:
		position -= event.relative*DRAGFACTOR