extends Control

func _ready():
	# Called every time the node is added to the scene.
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")

func _on_host_pressed():
	# TODO: Steal check-if-ip-in-use code from Multiplayer platformer demo / TDRacer v0.5
	if get_node("connect/name").text == "":
		get_node("connect/error_label").text = "Invalid name!"
		return
	get_node("connect").hide()
	get_node("players").show()
	get_node("vehicle_select").show()
	get_node("connect/error_label").text = ""
	var player_name = get_node("connect/name").text
	gamestate.host_game(player_name)
	refresh_lobby()

func _on_join_pressed():
	if get_node("connect/name").text == "":
		get_node("connect/error_label").text = "Invalid name!"
		return
	var ip = get_node("connect/ip").text
	if not ip.is_valid_ip_address():
		get_node("connect/error_label").text = "Invalid IPv4 address!"
		return
	get_node("connect/error_label").text=""
	get_node("connect/host").disabled = true
	get_node("connect/join").disabled = true
	var player_name = get_node("connect/name").text
	gamestate.join_game(ip, player_name)
	# refresh_lobby() gets called by the player_list_changed signal

func _on_connection_success():
	get_node("connect").hide()
	get_node("players").show()
	get_node("vehicle_select").show()

func _on_connection_failed():
	get_node("connect/host").disabled = false
	get_node("connect/join").disabled = false
	get_node("connect/error_label").set_text("Connection failed.")

func _on_game_ended():
	show()
	get_node("connect").show()
	get_node("players").hide()
	get_node("connect/host").disabled = false
	get_node("connect/join").disabled

func _on_game_error(errtxt):
	get_node("error").dialog_text = errtxt
	get_node("error").popup_centered_minsize()

func refresh_lobby(): # sync func?
	var players = gamestate.get_players()
	var players_choosing = gamestate.get_players_choosing()
	print(players)
	print(players_choosing)
	#players.sort()
	get_node("players/list").clear()
	if gamestate.player_choosing:
		get_node("players/list").add_item(gamestate.get_player_name() + " (You) [Choosing vehicle...]")
	else:
		get_node("players/list").add_item(gamestate.get_player_name() + " (You) [Ready.]")
	for p_id in players:
		var p = players[p_id]
		if players_choosing[p_id]:
			if p_id == get_tree().get_network_unique_id():
				p += " (You) [Choosing vehicle...]"
			else:
				p += " [Choosting vehicle...]"
		else:
			if p_id == get_tree().get_network_unique_id():
				p += " (You) [Ready.]"
			else:
				p += " [Ready.]"
		get_node("players/list").add_item(p)

	get_node("players/start").disabled = not get_tree().is_network_server()

func _on_start_pressed():
	# TODO: has everyone chosen?
	gamestate.begin_game()

func free_child_nodes(node):
	for child in node.get_children():
		child.queue_free()

func display_vehicle_image(vehicle_scene, animation):
	# TODO Check if spawning nodes in code [read() maybe] is better for lots of vehicle options
	# Free vehicle image
	var vehicle_img = get_node("vehicle_select/vehicle_image")
	free_child_nodes(vehicle_img)
	var car = load(vehicle_scene).instance()
	car.set_animation(animation)
	#car.set_frame(0)
	car.play_animation()
	$vehicle_select/vehicle_image.add_child(car)

func _on_sedan_toggled(button_pressed):
	if button_pressed:
		_on_cavallo_toggled(false)
		$vehicle_select/vehicles/sedan_yellow.show()
		$vehicle_select/vehicles/sedan_white.show()
		$vehicle_select/vehicles/cavallo.set_pressed(false)
	else:
		$vehicle_select/vehicles/sedan_yellow.hide()
		$vehicle_select/vehicles/sedan_white.hide()

func _on_cavallo_toggled(button_pressed):
	if button_pressed:
		_on_sedan_toggled(false)
		$vehicle_select/vehicles/cavallo_black.show()
		$vehicle_select/vehicles/cavallo_blue.show()
		$vehicle_select/vehicles/cavallo_grey.show()
		$vehicle_select/vehicles/sedan.set_pressed(false)
	else:
		$vehicle_select/vehicles/cavallo_black.hide()
		$vehicle_select/vehicles/cavallo_blue.hide()
		$vehicle_select/vehicles/cavallo_grey.hide()

func _on_cavallo_black_pressed():
	# TODO Check if putting these paths in a dictionary is a good idea
	# Set vehicle and colour
	var player_scene = "res://assets/vehicles/cavallo/cavallo.tscn"
	var player_animation = "black"
	vehicle_select(player_scene, player_animation)

func _on_sedan_yellow_pressed():
	# Set vehicle and colour
	var player_scene = "res://assets/vehicles/basic_sedan/basic_sedan.tscn"
	var player_animation = "yellow"
	vehicle_select(player_scene, player_animation)

func _on_sedan_white_pressed():
	# Set vehicle and colour
	var player_scene = "res://assets/vehicles/basic_sedan/basic_sedan.tscn"
	var player_animation = "white"
	vehicle_select(player_scene, player_animation)

func _on_cavallo_grey_pressed():
	# Set vehicle and colour
	var player_scene = "res://assets/vehicles/cavallo/cavallo.tscn"
	var player_animation = "grey"
	vehicle_select(player_scene, player_animation)

func _on_cavallo_blue_pressed():
	# Set vehicle and colour
	var player_scene = "res://assets/vehicles/cavallo/cavallo.tscn"
	var player_animation = "blue"
	vehicle_select(player_scene, player_animation)

func vehicle_select(player_scene, player_animation):
	gamestate.set_vehicle_properties(player_scene, player_animation)
	display_vehicle_image(player_scene, player_animation)