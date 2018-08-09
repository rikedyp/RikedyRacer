extends KinematicBody2D

# These variables determine handling of different vehicle types
export (int) var top_speed
export (float) var power # larger accelerates faster
# TODO just reverse power? Reconsider vehicle properties
export (float) var braking
export (float) var handling # larger is easier to turn, should be whole number
export (float) var friction # friction > 1, larger stops sooner
export (bool) var active
# Sprite layer shift variable for fake voxel effect
export (int) var sprite_shift = 0
var direction = Vector2(0,-1) # direction vector determines animated_sprite frame (Cartesian / top-down perspective)
#var theta = 0# vehicle rotation angle (0 = North, pi = South)
var now_speed # change the top speed
var velocity = Vector2() # velocity in Euclidean plane
var vel_iso = Vector2() # velocity vector for move_and_collide (isometric)
var line_to_draw = Vector2()
var theta = 0 # vehicle rotation angle from North in radians
var time = 0.00
var checkpoint = 0
var lap = 1
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
	#set_animation_frame(x,y)
	#rotate_vehicle(angle)

slave func set_lap_time():
	pass

slave func set_time(t):
	time = t

func rotate_vehicle(angle):
	for child in $sprite_layers.get_children():
		if child is Sprite:
			child.rotate(angle)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	# Shift sprite layers for fake 3d effect
	var i = 0
	for layer in $sprite_layers.get_children():
		var j = i * sprite_shift
		layer.position += Vector2(-j, 0)
		i += 1
	# Set up movement variables
	now_speed = top_speed
	handling = 0.04
	theta = 5*TAU/8
	rotate_vehicle(theta)
	#$animated_sprite.set_frame(0)

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
	# Rotate sprite layers
	rotate_vehicle(torque)
	#direction.x = direction.y * 2
	# Calculate acceleration vector
	var acceleration = direction * thrust
	# Accelerate
	velocity += acceleration * delta
	# Limit speed
	if velocity.length() > now_speed:
		velocity = now_speed*velocity.normalized()
	# Isometrize velocity
	var x = velocity.x
	var y = velocity.y
	vel_iso.x = x - y
	vel_iso.y = (x + y) / 2
	# Move car
	var collision = move_and_collide(vel_iso*delta)
	#var collision = move_and_slide(vel_iso*delta)
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

	#set_animation_frame(x,y)
	line_to_draw = vel_iso / 5
	#rpc("set_pos_and_motion",position,vel_iso,x,y)
	#
	#update()

func play_animation():
	$animated_sprite.play()

func _draw():
	draw_line(Vector2(), line_to_draw, Color(0.1,0.8,0.3,1))

func set_animation(animation):
	$animated_sprite.set_animation(animation)

func set_frame(frame):
	$animated_sprite.set_frame(frame)

func get_speed():
	return now_speed

func set_speed(speed):
	now_speed = speed

func set_animation_frame(x,y):
	if x == -1:
		if y < 0:
			# NWW
			$animated_sprite.set_frame(13)
			$hit_box.rotation_degrees = -120
		elif y > 0:
			# SWW
			$animated_sprite.set_frame(11)
			$hit_box.rotation_degrees = -165
		else:
			# West
			$animated_sprite.set_frame(12)
			$hit_box.rotation_degrees = -150
	elif x == -0.75:
		if y < 0:
			# NW
			$animated_sprite.set_frame(14)
			$hit_box.rotation_degrees = -90
		else:
			# SW
			$animated_sprite.set_frame(10)
			$hit_box.rotation_degrees = 180
	elif x < 0:
		if y < 0:
			# NNW
			$animated_sprite.set_frame(15)
			$hit_box.rotation_degrees = -60
		else:
			# SSW
			$animated_sprite.set_frame(9)
			$hit_box.rotation_degrees = 165
	elif x == 0.75:
		if y < 0:
			# NE
			$animated_sprite.set_frame(2)
			$hit_box.rotation_degrees = 0
		else:
			# SE
			$animated_sprite.set_frame(6)
			$hit_box.rotation_degrees = 90
	elif x == 1:
		if y < 0:
			# NEE
			$animated_sprite.set_frame(3)
			$hit_box.rotation_degrees = 15
		elif y > 0:
			# SEE
			$animated_sprite.set_frame(5)
			$hit_box.rotation_degrees = 60
		else:
			# East
			$animated_sprite.set_frame(4)
			$hit_box.rotation_degrees = 30
	elif x > 0:
		if y < 0:
			# NNE
			$animated_sprite.set_frame(1)
			$hit_box.rotation_degrees = -15
		else:
			# SSE
			$animated_sprite.set_frame(7)
			$hit_box.rotation_degrees = 120
	else:
		if y < 0:
			# North
			$animated_sprite.set_frame(0)
			$hit_box.rotation_degrees = -30
		else:
			# South
			$animated_sprite.set_frame(8)
			$hit_box.rotation_degrees = 150

func _physics_process(delta):
	if active:# and is_network_master():
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
		#update()
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func temp_disable(time):
	# temporarily disable player
	active = false
	$timer.wait_time = time
	$timer.one_shot = true
	$timer.start()

func temp_slow(temp_speed, time):
	# temporarily slow player
	now_speed = temp_speed
	$timer.wait_time = time
	$timer.one_shot = true
	$timer.start()

func _on_timer_timeout():
	active = true
	now_speed = top_speed
	pass # replace with function body
