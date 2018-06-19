extends "res://lib/playablechar.gd"

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _nearby():
	# Function when current playable character is touching
	# CollisionShape2D
	if Input.is_action_just_pressed("ui_select"):
		print("select!!")
		tie.buff_clear()
		tie.buff_text("Arrrrgh! Aye bee the pairat! Wud ye laik te bee mee???", 0.05)
		tie.add_newline()
		tie.buff_text("y/n: ")
		tie.set_state(tie.STATE_OUTPUT)
		tie.buff_input()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
