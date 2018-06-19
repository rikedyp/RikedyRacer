extends KinematicBody2D
export (int) var MASS  # how fast the player will move (pixels/sec)
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
	# Isometrize motion
	velocity = velocity + acceleration * delta
	var x = velocity.x
	var y = velocity.y
	var vel_iso = Vector2()
	vel_iso.x = x - y
	vel_iso.y = (x + y) / 2
	# Move car
	position += vel_iso * delta
    # Clamp inside screen
	#position.x = clamp(position.x, 0, screensize.x)
	#position.y = clamp(position.y, 0, screensize.y)
	if velocity.x > 0:
		# right
		if velocity.y > 0:
			# right down
			$AnimatedSprite.set_frame(6)
		elif velocity.y < 0:
			# right up
			$AnimatedSprite.set_frame(2)
		else:
			# right straight
			$AnimatedSprite.set_frame(4)
	elif velocity.x < 0:
		# left
		if velocity.y > 0:
			# left down
			$AnimatedSprite.set_frame(10)
		elif velocity.y < 0:
			# left up
			$AnimatedSprite.set_frame(14)
		else:
			# left straight
			$AnimatedSprite.set_frame(12)
	else:
		if velocity.y > 0:
			# down
			$AnimatedSprite.set_frame(8)
		elif velocity.y < 0:
			# up
			$AnimatedSprite.set_frame(0)
		else:
			# still
			pass

func _process(delta):
	_handleinput(delta)
	pass
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.


func _on_Area2D_body_entered(body):
	print(body)
	pass # replace with function body


func _on_Area2D_body_exited(body):
	pass # replace with function body
