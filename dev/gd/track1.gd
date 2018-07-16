extends Node2D
export (int) var max_laps = 2
export (int) var countdown = 3
export (float) var top_speed
export (float) var grass_speed
var camera
var dir
signal update_scoreboard

func _ready():
	# Connect checkpoint signals
#	for checkpoint in $checkpoints.get_children():
#		checkpoint.connect("lap_passed", self, "lap")
	get_node("checkpoints/0").connect("lap_passed", self, "lap")
	# Connect scoreboard signal
	#connect("refresh_scoreboard", self, "update_scoreboard")
	$HUD/lap.text = "1/" + str(max_laps)
	call_deferred("disable_players")
	$HUD/countdown_panel.show()
	$HUD/countdown.show()
	$HUD/countdown.text = str(countdown)
	$HUD/timer.start()

func _on_checkpoint_entered():
	pass

func disable_players():
	for player in $players.get_children():
		player.active = false
		print(player.get_name() + " ready.")

func activate_players():
	for player in $players.get_children():
		player.active = true

func _process(delta):
	pass
	# Display race time on HUD
	if gamestate.my_player.lap < max_laps + 1: 
		$HUD/clock.text = str(stepify(gamestate.my_player.time,0.1))

func show_lobby():
	var lobby = load("res://Scenes/Lobby.tscn").instance()
	get_tree().get_root().add_child(lobby)

func _on_HUD_countdown_timeout():
	if countdown > -1:
		countdown -= 1
		if countdown == 0:
			#ActivePlayer.ACTIVE = true
			gamestate.my_player.active = true
			$HUD/countdown.hide()
			$HUD/countdown_panel.hide()
		$HUD/countdown.text = str(countdown)
	else:
		$HUD/timer.stop()

func free_child_nodes(node):
	# TODO is this still used?
	for child in node.get_children():
		child.free()

func _on_grass_body_entered(body):
	top_speed = body.top_speed
	body.top_speed = grass_speed

func _on_grass_body_exited(body):
	body.top_speed = top_speed

func lap(player):
	print("lap")
	print(player.get_name())
	if int(player.get_name()) == get_tree().get_network_unique_id():
	# TODO Send lap times to other players for score board
	# Update my player's lap record
		gamestate.my_player.lap += 1
		gamestate.my_player.lap_times.append(gamestate.my_player.time)
		# Display lap # / time on HUD
		$HUD/lap.text = str(gamestate.my_player.lap) + "/" + str(max_laps)
		if gamestate.my_player.lap > max_laps:
			# Race finished, disable player
			gamestate.my_player.active = false
			#gamestate.my_player.score.erase(0) # maybe this?
			print("RACE OVER")
			$HUD/lap.text = str(max_laps) + "/" + str(max_laps)
			#refresh_scoreboard()
			
			gamestate.rpc("update_score", get_tree().get_network_unique_id(), gamestate.my_player.lap_times)
			rpc("refresh_scoreboard")
			$HUD/scoreboard.show()

sync func refresh_scoreboard():
	print("refersh scoreboard")
	var scoreboard = $HUD/scoreboard/scores
	free_child_nodes(scoreboard)
	var score_list = VBoxContainer.new()
	var my_name = Label.new()
	my_name.text = gamestate.my_player_info["name"]
	score_list.add_child(my_name)
	for lap_time in gamestate.my_player.lap_times:
		#print(lap_time)
		var lap_label = Label.new()
		lap_label.text = str(stepify(lap_time, 0.1))
		score_list.add_child(lap_label)
	scoreboard.add_child(score_list)
	for p_id in gamestate.players:
		var player_score_list = VBoxContainer.new()
		print(gamestate.players[p_id]["name"])
		var player_name = Label.new()
		player_name.text = gamestate.players[p_id]["name"]
		player_score_list.add_child(player_name)
		for lap in gamestate.players[p_id]["score"]:
			print(lap)
			var score_label = Label.new()
			score_label.text = str(stepify(lap,0.1))
			player_score_list.add_child(score_label)
		scoreboard.add_child(player_score_list)
		#print("---")
		#var score_label = Label.new()
