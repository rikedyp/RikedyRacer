extends Node2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dragging = false
var in_pitstop = false
export (float) var drag_factor

var current_towers = {}
var selected_tower

# Menu choice signals
signal choose_shotgun
signal choose_laser
signal choose_mg
# for child in tower_menu.get_children():
#	create signal?

sync func spawn_tower(owner_id, base_name, spawn_pos, tower_type, enemies):
	#print("spwan tower")
	var tower = load(tower_type).instance()
	#spawn_pos.x += 20
	tower.position = spawn_pos
	#tower.set_name(base_name)
	for enemy in enemies:
		tower.set_enemy(enemy)
	get_parent().add_child(tower)
	#get_parent().get_node("towers/"+base_name+"/base").disabled = true
	get_parent().get_node("towers/"+base_name+"/base").hide()
	#get_parent().get_node("towers/"+base_name+"/base").set_focus_mode(0)

sync func select_tower(tower):
	selected_tower = tower
	print(tower + " selected")

sync func upgrade_tower(tower, level):
	pass
	# tower.animation = level

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
	elif Input.is_action_pressed("ui_click") and in_pitstop:
		dragging = true
	else:
		dragging = false
#	if dragging:
#			$tower_menu.hide()
#			$upgrade_menu.hide()
	# For player in group "bad_guys"
#
#
func _input(event):
		#set_cellv(tile_pos, _tileset.find_tile_by_name("FireTower"))
	if event is InputEventMouseMotion and dragging:
		position -= event.relative*drag_factor
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom(-0.1)
		if event.button_index == BUTTON_WHEEL_DOWN:
			zoom(0.1)

func zoom(dir):
	$camera.zoom.x += dir
	$camera.zoom.y += dir

func _on_laser_pressed():
	$tower_menu.hide()
	emit_signal("choose_laser")

func _on_mg_pressed():
	$tower_menu.hide()
	emit_signal("choose_mg")

func _on_tower0_pressed():
	rpc("select_tower","tower0")
	#get_parent().get_node("towers/tower0/base").disabled = true
	$tower_menu.show()
	pass # replace with function body

func _on_tower1_pressed():
	rpc("select_tower", "tower1")
	$tower_menu.show()
	pass # replace with function body

func _on_shotgun_upgrade_pressed():
	#for node in get_parent().get_children():
	print(get_parent().get_node("shotgun1"))
	get_parent().get_node("shotgun1").set_level("level2")
	pass # replace with function body

#func _on_TextureButton_pressed():
#	$tower_menu.hide()
#	$upgrade_menu.hide()
#	pass # replace with function body

func _on_tower_menu_shotgun_pressed():
	print("choose shotgun tower")
	#get_parent().get_node("towers/tower0/base").hide()
	var spawn_pos = get_parent().get_node("towers/"+selected_tower).position
	var tower_type = "res://assets/towers/shotgun/shotgun.tscn"
	var enemies = get_enemies()
	rpc("spawn_tower", get_tree().get_network_unique_id(), selected_tower, spawn_pos, tower_type, enemies)
	print(get_parent().get_name())
	$tower_menu.hide()

func _on_tower_menu_mg_pressed():
	#	print("choose mg tower")
	var spawn_pos = get_parent().get_node("towers/"+selected_tower).position
	var tower_type = "res://assets/towers/mg/mg.tscn"
	var enemies = get_enemies()
	rpc("spawn_tower", get_tree().get_network_unique_id(), selected_tower, spawn_pos, tower_type, enemies)
	$tower_menu.hide()

func get_enemies():
	var enemies = []
	# --- So can test behaviour on self 
	#enemies.append(get_tree().get_network_unique_id())
	# /---
	for enemy in gamestate.players:
		enemies.append(enemy)
	return enemies
