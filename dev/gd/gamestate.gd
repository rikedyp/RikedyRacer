extends Node

# Default game port
const DEFAULT_PORT = 14204 # 8910

# Max number of players
const MAX_PEERS = 6

# Game # laps
var max_laps = 3

# Details for my player
var my_player
var my_player_info = {
	"name": "",
	"scene_file": "",
	"animation": "", # TODO Alter this so animated characters are easy in future
	"ready": false,
	"score": [] # List of lap times
	} 
# Details for remote players 
var players = {} # dict by id:profile format
# where profile is a dict "property": value
# {id: {"name": "player_name", "scene_file" = "player_scene_path"}} etc.
# name, scene, animation, ready, score

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
			emit_signal("game_error", "Player " + players[id]["name"] + " disconnected")
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
	rpc("register_player", get_tree().get_network_unique_id(), my_player_info)
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

remote func register_player(id, new_player_dict):
	# TODO set # laps
	if get_tree().is_network_server():
		# If we are the server, let everyone know about the new player
		rpc_id(id, "register_player", 1, my_player_info) # Send myself to newly connected player
		for p_id in players: # Then, for each remote player
			rpc_id(id, "register_player", p_id, players[p_id]) # Send existing player to new player
			rpc_id(p_id, "register_player", id, new_player_dict) # Send new player to existing player
	players[id] = new_player_dict
	emit_signal("player_list_changed")

remote func unregister_player(id):
	players.erase(id)
	emit_signal("player_list_changed")

remote func register_vehicle(id, new_player_scene, new_player_animation):
	if new_player_scene == "":
		players[id]["ready"] = false
	else:
		players[id]["ready"] = true
	players[id]["scene_file"] = new_player_scene
	players[id]["animation"] = new_player_animation
	emit_signal("player_list_changed")

remote func pre_start_game(spawn_points, max_laps):
	# Change scene
	var world = load("res://assets/stages/track1.tscn").instance()
	world.max_laps = max_laps
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("lobby").hide()
	#var player_scene = load(vehicle_scene)
	for p_id in spawn_points:
		var spawn_pos = world.get_node("spawn_points/" + str(spawn_points[p_id])).position
		var player
		if p_id == get_tree().get_network_unique_id():
			# If node for this peer id, set up player here
			my_player = load(my_player_info["scene_file"]).instance()
			player = my_player
			player.set_name(str(p_id)) # set unique id as node name
			player.position = spawn_pos
			player.set_player_name(my_player_info["name"])
			player.set_animation(my_player_info["animation"])
			player.set_camera()
		else:
			# Otherwise set up player from peer
			player = load(players[p_id]["scene_file"]).instance()
			player.set_name(str(p_id))
			player.position = spawn_pos
			player.set_player_name(players[p_id]["name"])
			player.set_animation(players[p_id]["animation"])
		player.set_network_master(p_id) #set unique id as master
		world.get_node("players").add_child(player)
	if not get_tree().is_network_server():
		# Tell server we are ready to start
		rpc_id(1, "ready_to_start", get_tree().get_network_unique_id())
	elif players.size() == 0:
		post_start_game()

remote func post_start_game():
	get_tree().set_pause(false) # Unpause and unleash the game!

remote func ready_to_start(id):
	assert(get_tree().is_network_server())
	for player in players:
		rpc_id(player, "post_start_game")
	post_start_game()

func host_game(new_player_name):
	my_player_info["name"] = new_player_name
	var host = NetworkedMultiplayerENet.new()
	#host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = host.create_server(DEFAULT_PORT, MAX_PEERS) # max: 1 peer, since it's a 2 players game
	if (err!=OK):
		#is another server running?
		emit_signal("game_error", "IP address in use or invalid.")
		end_game()
	get_tree().set_network_peer(host)

func join_game(ip, new_player_name):
	my_player_info["name"] = new_player_name
	#my_player["score"][0] = "Still racing"
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)

func get_players_ready():
	pass
#	var players_ready = []
#	for player in players:
#		players_ready.append(players[player]["ready"])
#	return players_ready

func begin_game():
	if not my_player_info["ready"]:
		# TODO GUI Warning
		var printstring = gamestate.my_player["name"] + " yet to choose vehicle"
		print(printstring)
		return
	else:
		for p in players:
			if not players[p]["ready"]:
				var printstring = players[p]["name"] + " yet to choose vehicle..."
				print(printstring)
				return
	# TODO: verify all connected players have chosen vehicles
	assert(get_tree().is_network_server())

	# Create a dictionary with peer id and respective spawn points, vehicle scenes and vehicle animations, could be improved by randomizing spawn points
	var spawn_points = {}
	spawn_points[1] = 0 # Server in spawn point 0
	var spawn_point_idx = 1
	# Assign spawn points
	for p in players:
		spawn_points[p] = spawn_point_idx
		spawn_point_idx += 1
	# Call to pre-start game with the spawn points, vehicle types and colours
	for p in players:
		rpc_id(p, "pre_start_game", spawn_points, max_laps)

	pre_start_game(spawn_points, max_laps)

func see_children(node):
	print("-----")
	for child in node.get_children():
		print(child.get_name())
		see_children(child)

func end_game():
	print("--- end game")
	#see_children(get_tree().get_root())
	print("---")
	# TODO generalise for any scene (levels)
	if has_node("/root/track1"): # Game is in progress
		# End it
		print("has it")
		get_node("/root/track1").queue_free()
		# TODO free the level properly
	get_tree().change_scene("res://lobby.tscn")
	emit_signal("game_ended")
	players.clear()
	get_tree().set_network_peer(null) # End networking

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func set_vehicle_properties(scene_file, animation):
	my_player_info["ready"] = true
	my_player_info["scene_file"] = scene_file
	my_player_info["animation"] = animation
	rpc("register_vehicle", get_tree().get_network_unique_id(), scene_file, animation)
	emit_signal("player_list_changed")
	
func still_choosing():
	my_player_info["ready"] = false
	emit_signal("player_list_changed")

sync func set_max_laps(laps):
	max_laps = laps

remote func update_score(id, score):
	players[id]["score"] = score
