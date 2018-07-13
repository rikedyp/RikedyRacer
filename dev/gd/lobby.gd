extends Control

var player_scene
var player_animation

func _ready():
	# Called every time the node is added to the scene.
	gamestate.connect("connection_failed", self, "_on_connection_failed")
	gamestate.connect("connection_succeeded", self, "_on_connection_success")
	gamestate.connect("player_list_changed", self, "refresh_lobby")
	gamestate.connect("game_ended", self, "_on_game_ended")
	gamestate.connect("game_error", self, "_on_game_error")

func ip_in_use():
	get_node("connect").show()
	get_node("players").hide()
	get_node("vehicle_select").hide()
	get_node("connect/error_label").text = "IP address in use"

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
	get_node("vehicle_select").hide()
	get_node("connect/host").disabled = false
	get_node("connect/join").disabled

func _on_game_error(errtxt):
	get_node("error").dialog_text = errtxt
	get_node("error").popup_centered_minsize()

func refresh_lobby(): # sync func?
	var players = gamestate.get_players()
	var players_choosing = gamestate.get_players_choosing()
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
	# TODO is this still used?
	for child in node.get_children():
		child.queue_free()

func display_vehicle_image(vehicle_scene, animation):
	# TODO Check if spawning nodes in code [read() maybe] is better for lots of vehicle options
	# Free vehicle image
	var vehicle_img = get_node("vehicle_select/vehicle_image")
	var car = load(vehicle_scene).instance()
	car.set_animation(animation)
	#car.set_frame(0)
	car.play_animation()
	$vehicle_select/vehicle_image.add_child(car)

func _on_sedan_toggled(button_pressed):
	if button_pressed:
		_on_cavallo_toggled(false)
		$vehicle_select/vehicle_buttons/sedan_yellow.show()
		$vehicle_select/vehicle_buttons/sedan_white.show()
		$vehicle_select/vehicle_buttons/cavallo.set_pressed(false)
	else:
		$vehicle_select/vehicle_buttons/sedan_yellow.hide()
		$vehicle_select/vehicle_buttons/sedan_white.hide()

func _on_cavallo_toggled(button_pressed):
	if button_pressed:
		_on_sedan_toggled(false)
		$vehicle_select/vehicle_buttons/cavallo_black.show()
		$vehicle_select/vehicle_buttons/cavallo_blue.show()
		$vehicle_select/vehicle_buttons/cavallo_grey.show()
		$vehicle_select/vehicle_buttons/sedan.set_pressed(false)
	else:
		$vehicle_select/vehicle_buttons/cavallo_black.hide()
		$vehicle_select/vehicle_buttons/cavallo_blue.hide()
		$vehicle_select/vehicle_buttons/cavallo_grey.hide()

func _on_cavallo_black_pressed():
	# TODO Check if putting these paths in a dictionary is a good idea
	# TODO Or even spawning buttons using code (might make more sense for unlockables)
	# Enable choose button
	$vehicle_select/choose.disabled = false
	# Set vehicle and colour
	player_scene = "res://assets/vehicles/cavallo/cavallo.tscn"
	player_animation = "black"
	$vehicle_select/vehicle_animations.set_animation("cavallo_black")

func _on_cavallo_grey_pressed():
	$vehicle_select/choose.disabled = false
	player_scene = "res://assets/vehicles/cavallo/cavallo.tscn"
	player_animation = "grey"
	$vehicle_select/vehicle_animations.set_animation("cavallo_grey")

func _on_cavallo_blue_pressed():
	$vehicle_select/choose.disabled = false
	player_scene = "res://assets/vehicles/cavallo/cavallo.tscn"
	player_animation = "blue"
	$vehicle_select/vehicle_animations.set_animation("cavallo_blue")

func _on_sedan_yellow_pressed():
	$vehicle_select/choose.disabled = false
	player_scene = "res://assets/vehicles/basic_sedan/basic_sedan.tscn"
	player_animation = "yellow"
	$vehicle_select/vehicle_animations.set_animation("sedan_yellow")

func _on_sedan_white_pressed():
	$vehicle_select/choose.disabled = false
	player_scene = "res://assets/vehicles/basic_sedan/basic_sedan.tscn"
	player_animation = "white"
	$vehicle_select/vehicle_animations.set_animation("sedan_white")

func _on_choose_toggled(button_pressed):
	if button_pressed:
		# Disable vehicle choice buttons
		for button in get_node("vehicle_select/vehicle_buttons").get_children():
			if button.get_class() == "TextureButton":
				button.disabled = true
	else:
		# Enable vehicle choice buttons
		for button in get_node("vehicle_select/vehicle_buttons").get_children():
			if button.get_class() == "TextureButton":
				button.disabled = false
	# Set vehicle properties for this player
	if button_pressed:
		$vehicle_select/choose.text = "CHOOSE AGAIN"
		gamestate.set_vehicle_properties(player_scene, player_animation)
	else:
		$vehicle_select/choose.text = "CHOOSE"
		gamestate.still_choosing()
	
	
