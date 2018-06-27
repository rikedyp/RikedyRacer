extends StaticBody2D

export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet # Needs changing for shotgun shell
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)
var enemy_name = ""
var target
var hit_pos
var can_shoot = true

func _ready():
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Visibility/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate
	#set_enemy("Player2")
	
func set_enemy(my_enemy):
	enemy_name = my_enemy

func _physics_process(delta):
	update()
	if target:
		aim()

func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node('CollisionShape2D').shape.extents - Vector2(5, 5)
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
			if result.collider.name == "Player1" or result.collider.name == "Player2":
				# TODO: Make this only apply to enemy player
				#$Sprite.self_modulate.r = 1.0
				#rotation = (target.position - position).angle()
				# Use this ^ to change animation frame
				set_image((target.position - position).angle())
				if can_shoot:
					shoot(pos)
				break

func set_image(angle):
	# Target moves from -pi(upleft) < -0(upright) < 0(downright) < pi(downleft)
	# -pi/2 directly above, +pi/2 directly below
	if -1.1781 < angle and angle < -0.3927:
		#target up right
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.animation = "level3"
	if -0.3927 < angle and angle < 0.3927:
		# target right
		$AnimatedSprite.set_frame(1)
	if 0.3927 < angle and angle < 1.1781:
		# target down right
		$AnimatedSprite.set_frame(2)
	if 1.1781 < angle and angle < 1.9635:
		# target down
		$AnimatedSprite.set_frame(3)
	if 1.9635 < angle and angle < 2.7489:
		# target down left
		$AnimatedSprite.set_frame(4)
	if angle < -2.7489 or angle > 2.7489:
		# target left
		$AnimatedSprite.set_frame(5)
	if -2.7489 < angle and angle < -1.9635:
		# target up left
		$AnimatedSprite.set_frame(6)
	if -1.9635 < angle and angle < -1.1781:
		# target up
		$AnimatedSprite.set_frame(7)
func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()

func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)

func _on_Visibility_body_entered(body):
	#print("Body entered")
	#print(body.get_name())
	#print(enemy_name)
	if target:
		return
	if body.get_name() == enemy_name:
		target = body


func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		#$Sprite.self_modulate.r = 0.2

func _on_ShootTimer_timeout():
	can_shoot = true
