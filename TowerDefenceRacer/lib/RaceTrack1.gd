extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var TowerScene = load("res://Scenes/Turret.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_PitStop_body_entered(body):
	print("In Pitstop")
	#$TowerCam.position = $Player/Camera.position
	$TowerCam/Camera.make_current()
	pass # replace with function body


func _on_PitStop_body_exited(body):
	print("Left pitstop")
	$Player/Camera.make_current()
	pass # replace with function body
