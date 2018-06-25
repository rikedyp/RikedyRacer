extends Area2D

var speed = 1000
var velocity = Vector2()

func _ready():
	pass

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta

func _on_Bullet_body_entered(body):
	if body.get_class() != "TileMap":
		#print(body.get_name())
		# TODO: if body.get_name() == Other_Player shoot
		# else: don't shoot
		if body.NOWSPEED > 50:
			body.NOWSPEED -= 30
		queue_free()