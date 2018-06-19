extends TileMap
export (int) var SPEED  # how fast the player will move (pixels/sec)


func _ready():


	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
    #$AnimatedSprite.play()
    var velocity = Vector2() # the player's movement vector
    if Input.is_action_pressed("ui_right"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_left"):
        velocity.x += 1
    if Input.is_action_pressed("ui_down"):
        velocity.y -= 1
    if Input.is_action_pressed("ui_up"):
        velocity.y += 1

    position += velocity * delta



#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
