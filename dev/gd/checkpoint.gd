extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal lap_passed

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	connect("body_entered", self, "checkpoint_entered")
	pass

func checkpoint_entered(body):
	# TODO advise on track set up to avoid unwanted lap routes
	if body.checkpoint + 1 > get_parent().get_child_count():
		body.checkpoint = 0
		lap(body)
	if int(self.get_name()) == body.checkpoint:
		body.checkpoint += 1
	elif int(self.get_name()) < body.checkpoint:
		body.checkpoint -= 1
	else:
		# probably cheating / went way off course probably reset player on track like Mario Kart
		print("other way")
	#print(body.get_name() + " entered checkpoint " + self.get_name() + " next " + str(body.checkpoint))

func lap(player):
	player.lap += 1
	emit_signal("lap_passed")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
