extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal shotgun_pressed
signal mg_pressed
signal laser_pressed

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_x_pressed():
	hide()
	pass # replace with function body

func _on_shotgun_pressed():
	emit_signal("shotgun_pressed")

func _on_mg_pressed():
	emit_signal("mg_pressed")

func _on_laser_pressed():
	emit_signal("laser_pressed")
