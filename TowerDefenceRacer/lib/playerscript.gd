extends KinematicBody2D
export (int) var TOPSPEED  # how fast the player will move (pixels/sec)
export (int) var ACCELERATION
export (float) var BRAKING
var velocity = Vector2()
var screensize  # size of the game window

func _ready():
	screensize = get_viewport_rect().size
	$AnimatedSprite.set_frame(2)
	$Camera.make_current()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _handleinput(delta):
	var force = Vector2() # the player's force vector
	var acceleration = Vector2()
	if Input.is_action_pressed("ui_right"):
		force.x += 1
	if Input.is_action_pressed("ui_left"):
		force.x -= 1
	if Input.is_action_pressed("ui_down"):
		# Backwards
		force.y += 1
	if Input.is_action_pressed("ui_up"):
		# Forwards
		force.y -= 1
	if force.length() > 0:
		acceleration = force.normalized() * ACCELERATION
	else:
		if velocity.length() > 0:
			velocity = velocity / BRAKING
	# Accelerate
	velocity = velocity + acceleration * delta
	# Limit speed
	# TODO
	# 	Friction / grass slow etc.
	if velocity.length() > TOPSPEED:
		velocity = TOPSPEED*velocity.normalized()
	var x = velocity.x
	var y = velocity.y
	# Isometrize motion
	var vel_iso = Vector2()
	vel_iso.x = x - y
	vel_iso.y = (x + y) / 2
	# Move car
	position += vel_iso * delta
    # Clamp inside screen
	#position.x = clamp(position.x, 0, screensize.x)
	#position.y = clamp(position.y, 0, screensize.y)
	# Change animated sprite frame depending on velocity
	var v = velocity.normalized()
	x = round((v.x*4))/4
	y = round((v.y*4))/4
	#var printstring = str(x)+', '+str(y)
	#print(printstring)
	var dir = [x,y]
	print(dir)	
	if y < 0:
		# North-east/west
		if x < -0.75:
			# NWW
			print("Weird1")
			$AnimatedSprite.set_frame(14)
		elif x < -0.5:
			print("NWW")
			$AnimatedSprite.set_frame(15)
		elif x < -0.25:
			print("NW")
			$AnimatedSprite.set_frame(0)
		elif x < 0:
			print("NNW")
			$AnimatedSprite.set_frame(1)
		elif x < 0.25:
			print("N")
			$AnimatedSprite.set_frame(2)
		elif x < 0.5:
			print("NNE")
			$AnimatedSprite.set_frame(3)
		elif x < 0.75:
			print("NE")
			$AnimatedSprite.set_frame(4)
		else:
			print("NEE")
			$AnimatedSprite.set_frame(5)
	elif y > 0:
		# South-east/west
		if x < -0.75:
			# SW
			print("Weird2")
		elif x < -0.5:
			print("SSW")
			$AnimatedSprite.set_frame(13)
		elif x < -0.25:
			print("SW")
			$AnimatedSprite.set_frame(12)
		elif x < 0:
			print("SWW")
			$AnimatedSprite.set_frame(11)
		elif x < 0.25:
			print("S")
			$AnimatedSprite.set_frame(10)
		elif x < 0.5:
			print("SSE")
			$AnimatedSprite.set_frame(9)
		elif x < 0.75:
			print("SE")
			$AnimatedSprite.set_frame(8)
		else:
			print("SEE")
			$AnimatedSprite.set_frame(7)
	else:
		# East or West
		if x < 0:
			print("West")
			$AnimatedSprite.set_frame(14)
		elif x > 0:
			print("East")
			$AnimatedSprite.set_frame(6)
		else:
			print("Still")
	
func _process(delta):
	_handleinput(delta)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.


func _on_Area2D_body_entered(body):
	print(body)
	pass # replace with function body


func _on_Area2D_body_exited(body):
	pass # replace with function body
