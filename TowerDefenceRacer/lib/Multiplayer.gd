extends KinematicBody2D
export (int) var TOPSPEED  # how fast the player will move (pixels/sec)
export (int) var GRASSSPEED
export (int) var ACCELERATION
export (float) var BRAKING
export (bool) var ACTIVE 
var NOWSPEED
var velocity = Vector2()
var lap = 0
var lap_times = []
var time = 0.0
var screensize  # size of the game window

#This updates the position on the other end
slave func set_pos_and_motion(p_pos,p_motion):
	position=p_pos
	velocity=p_motion
	# Animate slave vehicle
	var v = velocity.normalized()
	# To help quantize velocity to one of 8 directions
	var x = round((v.x*4))/4
	var y = round((v.y*4))/4
	set_animation(x,y)
	
slave func set_time(t):
	time = t

func _ready():
	screensize = get_viewport_rect().size
	$AnimatedSprite.set_frame(2)
	NOWSPEED = TOPSPEED
	lap = 0
	#if is_network_master():
#	if is_network_master():
#		ACTIVE = true
#	else:
#		ACTIVE = false
	#$Camera.make_current()
	# Called every time the node is added to the scene.
	# Initialization here

func handle_input(delta):
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
	if velocity.length() > NOWSPEED:
		velocity = NOWSPEED*velocity.normalized()
	var x = velocity.x
	var y = velocity.y
	# Isometrize motion
	var vel_iso = Vector2()
	vel_iso.x = x - y
	vel_iso.y = (x + y) / 2
	# Move car
	#position += vel_iso * delta
	var collision = move_and_collide(vel_iso*delta)
	if collision:
		print("Collision")
		print(collision)
    # Clamp inside screen
	#position.x = clamp(position.x, 0, screensize.x)
	#position.y = clamp(position.y, 0, screensize.y)
	# Change animated sprite frame depending on velocity
	var v = velocity.normalized()
	# To help quantize velocity to one of 8 directions
	x = round((v.x*4))/4
	y = round((v.y*4))/4
	var dir = [x,y]
	# Determine direction x -> y
	set_animation(x,y)
	
func set_animation(x,y):
	if x == -1:
		if y < 0:
			# NWW
			$AnimatedSprite.set_frame(15)
		elif y > 0:
			# SWW
			$AnimatedSprite.set_frame(13)
		else:
			$AnimatedSprite.set_frame(14)
			# West
	elif x == -0.75:
		if y < 0:
			# NW
			$AnimatedSprite.set_frame(0)
		else:
			# SW
			$AnimatedSprite.set_frame(12)
	elif x < 0:
		if y < 0:
			# NNW
			$AnimatedSprite.set_frame(1)
		else:
			# SSW
			$AnimatedSprite.set_frame(11)
	elif x == 0.75:
		if y < 0:
			# NE
			$AnimatedSprite.set_frame(4)
		else:
			# SE
			$AnimatedSprite.set_frame(8)
	elif x == 1:
		if y < 0:
			# NEE
			$AnimatedSprite.set_frame(5)
		elif y > 0:
			# SEE
			$AnimatedSprite.set_frame(7)
		else:
			# East
			$AnimatedSprite.set_frame(6)
	elif x > 0:
		if y < 0:
			# NNE
			$AnimatedSprite.set_frame(3)
		else:
			# SSE
			$AnimatedSprite.set_frame(9)
	else:
		if y < 0:
			# North
			$AnimatedSprite.set_frame(2)
		else:
			# South
			$AnimatedSprite.set_frame(10)

func _process(delta):
	if ACTIVE and is_network_master():
		# Handle input for this player
		handle_input(delta)
		time += delta
	# Send this player's motion to other player
	rpc("set_pos_and_motion",position,velocity)
	rpc("set_time", time)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func _on_Grass_body_entered(body):
	#print(body)
	NOWSPEED = GRASSSPEED

func _on_Grass_body_exited(body):
	NOWSPEED = TOPSPEED
	pass # replace with function body
