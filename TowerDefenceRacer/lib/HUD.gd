extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

# custom signal
signal countdown_timeout
signal back_to_lobby
slave var other_score

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Timer_timeout():
	emit_signal("countdown_timeout")

func _on_AgainButton_pressed():
	emit_signal("back_to_lobby")