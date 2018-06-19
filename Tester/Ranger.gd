xtends Area2D
export (int) var SPEED  # how fast the player will move (pixels/sec)
var screensize  # size of the game window
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var active = false
func _ready():
	screensize = get_viewport_rect().size

	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _handleinput(delta):
	$AnimatedSprite.play()
	var velocity = Vector2() # the player's movement vector
	if Input.is_action_pressed("ui_right"):
	   	velocity.x += 1
	if Input.is_action_pressed("ui_left"):
	   	velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
	   	velocity.y += 1
	if Input.is_action_pressed("ui_up"):
       	velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite.animation = "run"
	else:
       	$AnimatedSprite.animation = "idle"
	position += velocity * delta
    #position.x = clamp(position.x, 0, screensize.x)
    #position.y = clamp(position.y, 0, screensize.y)
	if velocity.x != 0:
	   	$AnimatedSprite.animation = "run"
	   	$AnimatedSprite.flip_v = false
	   	$AnimatedSprite.flip_h = velocity.x < 0

func _process(delta):
	if active:
    	_handleinput(delta)

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
