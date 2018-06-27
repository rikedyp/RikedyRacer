extends Node2D
# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var dragging = false
var in_pitstop = false
export (float) var DRAGFACTOR

# sync func called across server
sync func spawn_tower(enemy, spawn_pos):
	var tower_scene = load("res://Scenes/Shotgun.tscn")
	var tower = tower_scene.instance()
	tower.set_enemy(enemy)
	tower.position = spawn_pos # Vector2
	# spawn an instance of node 
	get_parent().add_child(tower)
	#print(tower.get_name())

func _ready():
	#set_process_input(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if Input.is_action_pressed("right_click"):
		dragging = true
	else:
		dragging = false
	if Input.is_action_just_pressed("left_click") and self.get_name() == "TowerCam2" and in_pitstop:
		var enemy_name = "Player1"
		var tower_pos = Vector2(get_global_mouse_position())
		rpc("spawn_tower", enemy_name, tower_pos)
	if Input.is_action_just_pressed("left_click") and self.get_name() == "TowerCam1" and in_pitstop:
		var enemy_name = "Player2"
		var tower_pos = Vector2(get_global_mouse_position())
		rpc("spawn_tower", enemy_name, tower_pos)
		#self.get_parent().add_child(new_tower)
		#new_tower.set_enemy("Player2")
	#elif Input.event
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.

func _input(event):
	if event is InputEventMouseMotion and dragging:
		position -= event.relative*DRAGFACTOR
