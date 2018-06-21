extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	for child in self.get_parent().get_children():
		print(child)
	draw_line(Vector2(), Vector2(500,500), Color(1,1,0))
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	pass
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
