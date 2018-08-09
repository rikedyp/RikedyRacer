extends Area2D

export (int) var speed = 1000
var slow_speed = 100
var slow_time = 0.4
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
		body.temp_slow(slow_speed, slow_time)
	queue_free()

func set_slow_variables(speed, time):
	# Set vehicle slow speed and slow time e.g. for tower upgrades
	slow_speed = speed
	slow_time = time