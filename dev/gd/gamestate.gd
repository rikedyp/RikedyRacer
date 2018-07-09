extends Node

# Default game port
const DEFAULT_PORT = 14204

# Max number of players
const MAX_PEERS = 2

# Details for my player
var player_name = ""
var player_scene = ""
var player_animation = ""
var player_choosing = true

# Details for remote players in id:value format
var players = {} # names
var player_scenes = {} # scene file paths
var player_animations = {} # player animation frame sets
var players_choosing = {} # is player still choosing vehicle? (bools)

# Signals to let lobby GUI know what's going on
signal player_list_changed()
signal connection_failed()
signal connection_succeeded()
signal game_ended()
signal game_error(what) # TODO change variable name

# Callback from SceneTree
func _player_connected(id):
	# This is not used in this demo, because _connected_ok is called for clients
	# on success and will do the job.
	pass

# Callback from SceneTree
func _player_disconnected(id):
	if get_tree().is_network_server():
		if has_node("/root/world"): # Game is in progress
			emit_signal("game_error", "Player " + players[id] + " disconnected")
			end_game()
		else: # Game is not in progress
			# If we are the server, send to the new dude all the already registered players
			unregister_player(id)
			for p_id in players:
				# Erase in the server
				rpc_id(p_id, "unregister_player", id)

# Callback from SceneTree, only for clients (not server)
func _connected_ok():
	# Registration of a client beings here, tell everyone that we are here
	rpc("register_player", get_tree().get_network_unique_id(), player_name)
	emit_signal("connection_succeeded")

# Callback from SceneTree, only for clients (not server)
func _server_disconnected():
	emit_signal("game_error", "Server disconnected")
	end_game()

# Callback from SceneTree, only for clients (not server)
func _connected_fail():
	get_tree().set_network_peer(null) # Remove peer
	emit_signal("connection_failed")

# Lobby management functions

remote func register_player(id, new_player_name):
	if get_tree().is_network_server():
		# If we are the server, let everyone know about the new player
		rpc_id(id, "register_player", 1, player_name) # Send myself to new dude
		for p_id in players: # Then, for each remote player
			rpc_id(id, "register_player", p_id, players[p_id]) # Send player to new dude
			rpc_id(p_id, "register_player", id, new_player_name) # Send new dude to player
	players[id] = new_player_name
	players_choosing[id] = true
	emit_signal("player_list_changed")

remote func unregister_player(id):
	players.erase(id)
	emit_signal("player_list_changed")

remote func register_vehicle(id, new_player_scene, new_player_animation):
	# TODO: Share the current choosing players list around network
	if get_tree().is_network_server():
		# If we are server, let everyone know about the vehicle choice
		rpc_id(id, "register_vehicle", 1, player_scene, player_animation)
		for p_id in players: # Then, for each remote player
			rpc_id(id, "register_vehicle", p_id, player_scenes[p_id], player_animations[p_id]) # Send player's vehicle to chooser
			rpc_id(p_id, "register_vehicle", id, new_player_scene, new_player_animation) # Send chooser's vehicle to player
	player_scenes[id] = new_player_scene
	player_animations[id] = new_player_animation
	players_choosing[id] = false
	
	emit_signal("player_list_changed")
	
remote func unregister_vehicle(id):
	player_scenes.erase(id)
	player_animations.erase(id)

remote func pre_start_game(spawn_points):
	# Change scene
	var world = load("res://stages/track1.tscn").instance()
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("lobby").hide()
	#var player_scene = load(vehicle_scene)
	for p_id in spawn_points:
		var spawn_pos = world.get_node("spawn_points/" + str(spawn_points[p_id])).position
		var player
		#print(player.camera)
		#player = load("res://assets/vehicles/cavallo/cavallo.tscn").instance()
		if p_id == get_tree().get_network_unique_id():
			# If node for this peer id, set up player here
			player = load(player_scene).instance()
			player.set_name(str(p_id)) # set unique id as node name
			player.position = spawn_pos
			player.set_player_name(player_name)
			player.set_animation(player_animation)
			player.set_camera()
		else:
			# Otherwise set up player from peer
			player = load(player_scenes[p_id]).instance()
			player.set_name(str(p_id))
			player.position = spawn_pos
			player.set_player_name(players[p_id])
			player.set_animation(player_animations[p_id])
		player.set_network_master(p_id) #set unique id as master
		player.set_active()
		world.get_node("players").add_child(player)

	# Set up score
#	world.get_node("score").add_player(get_tree().get_network_unique_id(), player_name)
#	for pn in players:
#		world.get_node("score").add_player(pn, players[pn])

	if not get_tree().is_network_server():
		# Tell server we are ready to start
		rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())
	elif players.size() == 0:
		post_start_game()

remote func post_start_game():
	get_tree().set_pause(false) # Unpause and unleash the game!

var players_ready = []

remote func ready_to_start(id):
	assert(get_tree().is_network_server())
	if not id in players_ready:
		players_ready.append(id)
	if players_ready.size() == players.size():
		for p in players:
			rpc_id(p, "post_start_game")
		post_start_game()

func host_game(new_player_name):
	player_name = new_player_name
	var host = NetworkedMultiplayerENet.new()
	host.create_server(DEFAULT_PORT, MAX_PEERS)
	get_tree().set_network_peer(host)

func join_game(ip, new_player_name):
	player_name = new_player_name
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)

func get_players():
	return players
	
func get_players_choosing():
	return players_choosing

func get_player_name():
	return player_name
	
func get_player_vehicle_properties():
	return player_scene
	
func get_player_animation():
	return player_animation

func begin_game():
	print(players_choosing)
	if player_choosing:
		var printstring = get_player_name() + " yet to choose vehicle"
		print(printstring)
		return
	else:
		for p in players_choosing:
			if p:
				var printstring = p + " yet to choose vehicle..."
				print(printstring)
				return
	# TODO: verify all connected players have chosen vehicles
	assert(get_tree().is_network_server())

	# Create a dictionary with peer id and respective spawn points, vehicle scenes and vehicle animations, could be improved by randomizing
	var spawn_points = {}
	spawn_points[1] = 0 # Server in spawn point 0
	var spawn_point_idx = 1
	# Assign spawn points
	for p in players:
		spawn_points[p] = spawn_point_idx
		spawn_point_idx += 1
	# Call to pre-start game with the spawn points, vehicle types and colours
	for p in players:
		rpc_id(p, "pre_start_game", spawn_points)

	pre_start_game(spawn_points)

func end_game():
	if has_node("/root/world"): # Game is in progress
		# End it
		get_node("/root/world").queue_free()

	emit_signal("game_ended")
	players.clear()
	get_tree().set_network_peer(null) # End networking

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func set_vehicle_properties(scene, animation):
	if scene == null:
		print("No vehicle chosen")
		return
	player_choosing = false
	player_scene = scene
	player_animation = animation
	var printstring = player_name + " vehicle set." 
	print(printstring)
	rpc("register_vehicle", get_tree().get_network_unique_id(), scene, animation)
	emit_signal("player_list_changed")