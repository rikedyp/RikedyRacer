extends Node2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dragging = false
var in_pitstop = false
export (float) var drag_factor

# Menu choice signals
signal choose_shotgun
signal choose_laser
signal choose_mg
# for child in tower_menu.get_children():
#	create signal?

# sync func called across server
sync func spawn_tower(enemy, spawn_pos):
	var tower = load("res://assets/towers/shotgun/shotgun.tscn").instance()
	tower.set_enemy(enemy)
	tower.position = spawn_pos.position#spawn_pos # Vector2
	# spawn an instance of node 
	get_parent().add_child(tower)
	#print(tower.get_name())

func _ready():
	#set_process_input(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
#	if in_pitstop:
	if Input.is_action_pressed("scroll_up"):
		print("scroll up")
		zoom(1)
	elif Input.is_action_pressed("scroll_down"):
		print("scroll down")
		zoom(0)
#	elif menu_pressed():
#		pass
#	elif Input.is_action_just_pressed("ui_click") and in_pitstop:
#			#var tile_pos = world_to_map(get_global_mouse_position())
#			#print(tile_pos)
#			# Highlight hover tile?
#			position = get_global_mouse_position()
#			$tower_menu.hide()
#			$menu.show()
#			print("tower click")
#			print(self.get_name())
			#dragging = true
	elif Input.is_action_pressed("ui_click") and in_pitstop:
		dragging = true
	else:
		dragging = false
#	if dragging:
#			$tower_menu.hide()
#			$menu.hide()
	# For player in group "bad_guys"
	
func zoom(dir):
	$camera.zoom.x += dir
	$camera.zoom.y += dir
#	if Input.is_action_just_pressed("ui_click") and self.get_name() == "ur mum":
#		var enemy_name = "Player1"
#		var tower_pos = Vector2(get_global_mouse_position())
#		rpc("spawn_tower", enemy_name, tower_pos)
#	if Input.is_action_just_pressed("left_click") and self.get_name() == "TowerCam1" and in_pitstop:
#		var enemy_name = "Player2"
#		var tower_pos = Vector2(get_global_mouse_position())
#		rpc("spawn_tower", enemy_name, tower_pos)
		#self.get_parent().add_child(new_tower)
		#new_tower.set_enemy("Player2")
	#elif Input.event
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func _input(event):
		#set_cellv(tile_pos, _tileset.find_tile_by_name("FireTower"))
	if event is InputEventMouseMotion and dragging:
		position -= event.relative*drag_factor
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom(-0.1)
		if event.button_index == BUTTON_WHEEL_DOWN:
			zoom(0.1)

func _on_shotgun_pressed():
	var spawn_pos = get_parent().get_node("towers/tower0")
	rpc("spawn_tower", get_tree().get_network_unique_id(), spawn_pos) 
	#$tower_menu/
	print(get_parent().get_name())
	$tower_menu.hide()
	emit_signal("choose_shotgun")

func _on_laser_pressed():
	$tower_menu.hide()
	emit_signal("choose_laser")

func _on_mg_pressed():
	$tower_menu.hide()
	emit_signal("choose_mg")

func _on_tower0_pressed():
	#$tower_menu.position = position
	print(get_parent().get_node("towers/tower0"))
	#$tower_menu.position.y += 10
	$tower_menu.show()
	pass # replace with function body
