extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export (int) var power
export (int) var braking
export (float) var handling
export (float) var friction
var velocity = Vector2()
var direction = Vector2(0,1)
#var now_speed = 0
var now_speed = 0.00
var theta = -3*PI/4
var line_to_draw = Vector2()

func _ready():
	for i in range(23):
		print(i)
	direction = Vector2(0,1)
	#now_speed = 0
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func rotate_vec(vector, theta):
	var rot = Vector2()
	rot.x = (vector.x*cos(theta) - vector.y*sin(theta))
	rot.y = (vector.x*sin(theta) + vector.y*cos(theta))
	return rot

func zoom(dir):
	$camera.zoom.x += dir
	$camera.zoom.y += dir

func _input(event):
		#set_cellv(tile_pos, _tileset.find_tile_by_name("FireTower"))
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom(-0.1)
		if event.button_index == BUTTON_WHEEL_DOWN:
			zoom(0.1)

func _process(delta):

	#update()
	var thrust = 0 # the player's thrust (forwards / backwards) vector
	var torque = 0 # player's instantaneous change in theta
	# TODO Touchscreen InputEventScreenDrag
	# or Touch Screen Buttons
	# TODO alternative control input
	if Input.is_action_pressed("ui_up"):
		thrust = power
		#print(PI)
	if Input.is_action_pressed("ui_down"):
		thrust = -braking
	if Input.is_action_pressed("ui_left"):
		torque = -handling
		rotate_vehicle(-handling)
	if Input.is_action_pressed("ui_right"):
		rotate_vehicle(handling)
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
	velocity = acceleration * delta
	move_and_collide(velocity)
	#line_to_draw = velocity*30
	#update()
	#$Label.text = str(direction) + " " + str(theta)
#	if Input.is_action_pressed("ui_up"):
#		now_speed -= speed
#	if Input.is_action_pressed("ui_right"):
#		#velocity.x += speed
#		for child in get_children():
#			if child is Sprite:
#				child.rotate(steering)

func _draw():
	print("darw")
	draw_line(Vector2(), line_to_draw, Color(0.1,0.8,0.3,1))

func rotate_vehicle(angle):
	for child in $sprite_layers.get_children():
		if child is Sprite:
			child.rotate(angle)
#		theta -= steering
#	if Input.is_action_pressed("ui_down"):
#		now_speed += speed
#	if Input.is_action_pressed("ui_left"):
#		#velocity.x -= speed
#		for child in get_children():
#			if child is Sprite:
#				child.rotate(-steering)
#		theta += steering
#	if velocity.length() > 0.01:
#		now_speed = now_speed / friction
#	else:
#		now_speed = 0
#	direction = rotate_vec(direction,theta)
#	$Label.text = str(direction)
#		#rotation_degrees -= steering
#	velocity = now_speed * direction
#	move_and_collide(velocity)
##	# Called every frame. Delta is time since last frame.
##	# Update game logic here.
##	pass
