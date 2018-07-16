extends KinematicBody2D

# These variables determine handling of different vehicle types
export (int) var top_speed
export (float) var power # larger accelerates faster
# TODO just reverse power? Reconsider vehicle properties
export (float) var braking
export (float) var handling # larger is easier to turn, should be whole number
export (float) var friction # friction > 1, larger stops sooner
var active
var direction = Vector2(0,-1) # direction vector determines animated_sprite frame (Cartesian / top-down perspective)
#var theta = 0# vehicle rotation angle (0 = North, pi = South)
var velocity = Vector2() # velocity in Euclidean plane
var vel_iso = Vector2() # velocity vector for move_and_collide (isometric)
var line_to_draw = Vector2()
var theta = 0 # vehicle rotation angle from North in radians
var time = 0.00
var checkpoint = 0
var lap = 0
var lap_times = []
var score = []

#This updates the position on the other end
slave func set_pos_and_motion(p_pos, p_vel_iso, p_dir):
	position = p_pos
	vel_iso = p_vel_iso
	var d = p_dir.normalized()
	# To help quantize acceleration to one of 8 (16?) directions
	var x = round((d.x*4))/4
	var y = round((d.y*4))/4
	# Animate slave vehicle
	set_animation_frame(x,y)
	
slave func set_lap_time():
	pass
	
slave func set_time(t):
	time = t

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	handling = 0.04
	theta = 5*TAU/8
	$animated_sprite.set_frame(0)

func set_player_name(new_name):
	get_node("label").set_text(new_name)

func set_camera():
	$camera.make_current()

func set_active():
	active = true

func handle_input(delta):
	#var acceleration = Vector2()
	var thrust = 0 # the player's thrust (forwards / backwards) vector
	var torque = 0 # player's instantaneous change in theta
	# TODO Touchscreen InputEventScreenDrag
	# or Touch Screen Buttons
	# TODO alternative control input
	if Input.is_action_pressed("throttle"):
		thrust = power
		#print(PI)
	if Input.is_action_pressed("brake"):
		thrust = -braking
	if Input.is_action_pressed("ui_left"):
		torque = -handling
	if Input.is_action_pressed("ui_right"):
		torque = handling
	# Quantize theta to number of car orientations
	#torque = stepify(torque, handling_step)
	if theta > -TAU/2 or theta < TAU/2:
		theta += torque 
	#theta = stepify(theta, handling_step)
	if theta < -TAU or theta > TAU:
		theta = 0
	# Calculate direction vector rotation
	direction.x = cos(theta) - sin(theta)
	direction.y = sin(theta) + cos(theta)
	#direction.x = direction.y * 2
	# Calculate acceleration vector
	var acceleration = direction * thrust
	# Accelerate
	velocity += acceleration * delta
	# Limit speed
	if velocity.length() > top_speed:
		velocity = top_speed*velocity.normalized()
	# Isometrize velocity
	var x = velocity.x
	var y = velocity.y
	vel_iso.x = x - y
	vel_iso.y = (x + y) / 2
	# Move car
	var collision = move_and_collide(vel_iso*delta)
	# Check collisions here (or make collision_check function)
#	if collision:
#		print("Collision")
#		print(collision.collider)
	# Apply friction 
	if thrust == 0:
		velocity = velocity / friction
	# Change animated sprite frame depending on direction
	var d = direction.normalized()
	# To help quantize acceleration to one of 8 (16?) directions
	x = round((d.x*4))/4
	y = round((d.y*4))/4
	# Determine direction x -> y
	set_animation_frame(x,y)
	line_to_draw = vel_iso / 5
	#rpc("set_pos_and_motion",position,vel_iso,x,y)
	update()

func play_animation():
	$animated_sprite.play()

func _draw():
	draw_line(Vector2(), line_to_draw, Color(0.1,0.8,0.3,1))

func set_animation(animation):
	$animated_sprite.set_animation(animation)

func set_frame(frame):
	$animated_sprite.set_frame(frame)

func get_top_speed():
	return top_speed
	
func set_top_speed(speed):
	top_speed = speed

func set_animation_frame(x,y):
	if x == -1:
		if y < 0:
			# NWW
			$animated_sprite.set_frame(13)
		elif y > 0:
			# SWW
			$animated_sprite.set_frame(11)
		else:
			$animated_sprite.set_frame(12)
			# West
	elif x == -0.75:
		if y < 0:
			# NW
			$animated_sprite.set_frame(14)
		else:
			# SW
			$animated_sprite.set_frame(10)
	elif x < 0:
		if y < 0:
			# NNW
			$animated_sprite.set_frame(15)
		else:
			# SSW
			$animated_sprite.set_frame(9)
	elif x == 0.75:
		if y < 0:
			# NE
			$animated_sprite.set_frame(2)
		else:
			# SE
			$animated_sprite.set_frame(6)
	elif x == 1:
		if y < 0:
			# NEE
			$animated_sprite.set_frame(3)
		elif y > 0:
			# SEE
			$animated_sprite.set_frame(5)
		else:
			# East
			$animated_sprite.set_frame(4)
	elif x > 0:
		if y < 0:
			# NNE
			$animated_sprite.set_frame(1)
		else:
			# SSE
			$animated_sprite.set_frame(7)
	else:
		if y < 0:
			# North
			$animated_sprite.set_frame(0)
		else:
			# South
			$animated_sprite.set_frame(8)

func _physics_process(delta):
	if active and is_network_master():
		handle_input(delta)
		#rset("slave_motion", vel_iso)
		#rset("slave_pos", position)
		time += delta
	else:
		pass#position = slave_pos
		#vel_iso = slave_motion
	# Send this player's motion to other players
	rpc("set_pos_and_motion",position,vel_iso,direction)
	rpc("set_time", time)

func _process(delta):
	if active:
		time += delta
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_hit_area_body_entered(body):
	print(body.get_name())
	print(body)
	pass # replace with function body
