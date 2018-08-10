extends StaticBody2D

export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet # Needs changing for shotgun shell
var vis_color = Color(.867, .91, .247, 0.1)
var laser_color = Color(1.0, .329, .298)
var owner_id
var enemies = []
var target
var hit_pos
var location
var can_shoot = true
var current_level = 1
var slow_speed = 100 # Vehicle speed when hit (level1)
var slow_time = 0.4 # Duration of vehicle slow when hit (level1)

func set_base(new_base):
	location = new_base

func set_owner(new_id):
	# Who owns this tower?
	owner_id = new_id

func _ready():
	# Connect signals
	connect("input_event", self, "_on_input_event")
	$upgrade_menu.connect("shotgun_upgrade", self, "_on_upgrade_menu_shotgun_upgrade")
	$visibility.connect("body_entered", self, "_on_visibility_body_entered")
	$visibility.connect("body_exited", self, "_on_visibility_body_exited")
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$visibility/collision_shape.shape = shape
	$shoot_timer.wait_time = fire_rate
	#set_enemy("Player2")
	
func set_enemy(new_foe):
	enemies.append(new_foe)

func _physics_process(delta):
	update()
	if target:
		aim()

func aim():
	hit_pos = []
	var space_state = get_world_2d().direct_space_state
	var target_extents = target.get_node("hit_box").shape.extents - Vector2(5, 5)
	var nw = target.position - target_extents
	var se = target.position + target_extents
	var ne = target.position + Vector2(target_extents.x, -target_extents.y)
	var sw = target.position + Vector2(-target_extents.x, target_extents.y)
	for pos in [target.position, nw, ne, se, sw]:
		var result = space_state.intersect_ray(position,
				pos, [self], collision_mask)
		if result:
			hit_pos.append(result.position)
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
	b.slow_speed = slow_speed
	b.slow_time = slow_time
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$shoot_timer.start()

func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)
	if target:
		for hit in hit_pos:
			draw_circle((hit - position).rotated(-rotation), 5, laser_color)
			draw_line(Vector2(), (hit - position).rotated(-rotation), laser_color)

func _on_ShootTimer_timeout():
	can_shoot = true

#func _on_click_area_input_event(viewport, event, shape_idx):
#
#	if event is InputEventMouseButton:
#		#print(event.button_index)
#		$upgrade_menu.show()
#		$upgrade_menu/shotgun.show()
#	#print("click are2")
#	#emit_signal("input_event", viewport, event, shape_idx)
#	pass # replace with function body

func _on_visibility_body_entered(body):
	if target:
		return
	if int(body.get_name()) in enemies:
		target = body
	pass # replace with function body

func _on_visibility_body_exited(body):
	if body == target:
		target = null
	pass # replace with function body

func _on_shoot_timer_timeout():
	can_shoot = true
	pass # replace with function body

func _on_input_event(viewport, event, shape_idx):
	#print(event)
	# Make sure only I can modify my towers
#	print("Who's TOWER???")
#	print(get_name())
#
#	print(owner)
#	print("------")
	if event is InputEventMouseButton and location in gamestate.my_towers:
		print(location)
		print(gamestate.my_towers)
		print("MY TOWER")
		#print(event.button_index)
		#print(event)
		$upgrade_menu.show()
		$upgrade_menu/shotgun.show()
	pass # replace with function body

func _on_visibility_input_event(viewport, event, shape_idx):
	print(event)
	pass # replace with function body

func _on_upgrade_menu_shotgun_upgrade():
	pass # replace with function body

func upgrade_level():
	# Can we afford the upgrade?
	if gamestate.my_player.r_coin < 40:
		print("Insufficient RCoin!")
		return
	gamestate.my_player.r_coin -= 40
	rpc("sync_upgrade")

sync func sync_upgrade():
	# Set current tower level and animation frames
	current_level += 1
	var new_level = "level" + str(current_level)
	var next_level = "level" + str(current_level+1)
	$animated_sprite.set_animation(new_level)
	$upgrade_menu/shotgun/shotgun_upgrade/animation.set_animation(next_level)
	# Set new projectile / bullet properties
	if current_level == 2:
		slow_speed = 80
		slow_time = 0.5
		$label.text = "80, 0.5"
	elif current_level == 3:
		slow_speed = 69
		slow_time = 0.8
		$label.text = "69, 0.8"
	pass
	
func set_label_text(text):
	$label.text = text