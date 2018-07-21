extends Area2D

export (int) var speed = 1000
var velocity = Vector2()

func _ready():
	pass

func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)

func _physics_process(delta):
	position += velocity * delta

func _on_bullet_body_entered(body):
	if body is KinematicBody2D:
		body.temp_slow(100, 0.4)
	queue_free()