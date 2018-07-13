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
	for checkpoint in $checkpoints.get_children():
		checkpoint.connect("lap_passed", self, "lap")
	# Connect scoreboard signal
	connect("refresh_scoreboard", self, "update_scoreboard")
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
	# Display race time on HUD
	if gamestate.my_player.lap < max_laps + 1: 
		$HUD/clock.text = str(stepify(gamestate.my_player.time,0.01))

func update_scores(body):
	# Get total time
	var total_time = gamestate.my_player.lap_times[max_laps-1]
	# TODO: for player in group("players") type deal for > 2 player
	# Display scoreboard
	var score_string = ""
	var lap_string = ""
	for lap in range(max_laps):
		var lap_time
		if lap > 0:
			lap_time = float(body.lap_times[lap]) - float(body.lap_times[lap-1])
		else:
			lap_time = float(body.lap_times[lap])
		var last_lap = lap_string
		var last_score = score_string
		lap_string = last_lap + "\nLap " + str(lap + 1) + ": " 
		score_string = last_score + "\n" + str(stepify(lap_time, 0.01))
		if lap == max_laps - 1:
			last_score = score_string
			lap_string = lap_string + "\n\nTotal: "
			score_string = last_score + "\n\n" + str(stepify(total_time, 0.01))
	if body.get_name() == "Player1":
		$HUD/Scoreboard/Player1/Lap.text = lap_string
		$HUD/Scoreboard/Player1/Score.text = score_string
	if body.get_name() == "Player2":
		$HUD/Scoreboard/Player2/Lap.text = lap_string
		$HUD/Scoreboard/Player2/Score.text = score_string
	#$HUD/Scoreboard.update()
	#scorestring = "Lap 1: " + body.lap_times[0]		
	# Update other players' scores when they finish
	# or wait til they finish to display all scores

func show_lobby():
	var lobby = load("res://Scenes/Lobby.tscn").instance()
	get_tree().get_root().add_child(lobby)

func _on_HUD_countdown_timeout():
	# gamestate.players_active[p_id] = true
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
		child.queue_free()

func _on_HUD_back_to_lobby():
	print("let's go back to the lobby")
	call_deferred("show_lobby")
#	if has_node("/root/Scenes/Multiplayer_TestTrack"):
#		get_node("/root/Scenes/Multiplayer_TestTrack").queue_free()
	get_tree().set_network_peer(null)
	$Player2.queue_free()
	$Player1.queue_free()
	queue_free()
	#get_tree().change_scene("res://Scenes/Lobby.tscn")

func _on_grass_body_entered(body):
	top_speed = body.top_speed
	body.top_speed = grass_speed

func _on_grass_body_exited(body):
	body.top_speed = top_speed

func lap():
	# TODO Send lap times to other players for score board
	# Update my player's lap record
	gamestate.my_player.lap_times.append(gamestate.my_player.time)
	#gamestate.player_score[gamestate.my_player.lap] = gamestate.my_player.time
	gamestate.my_player.lap += 1
	gamestate.update_scores(get_tree().get_network_unique_id(), gamestate.my_player.lap_times)
	emit_signal("update_scoreboard")
	if gamestate.my_player.lap > max_laps:
		gamestate.my_player.active = false
		gamestate.player_score.erase(0)
		print("RACE OVER")
		$HUD/lap.text = str(max_laps) + "/" + str(max_laps) + " FINISHED"
		var scoreboard = $HUD/scoreboard/scores
		free_child_nodes(scoreboard)
		var score_list = VBoxContainer.new()
		var my_name = Label.new()
		my_name.text = gamestate.player_name
		score_list.add_child(my_name)
		for lap_time in gamestate.my_player.lap_times:
			#print(lap_time)
			var lap_label = Label.new()
			lap_label.text = str(stepify(lap_time, 0.01))
			score_list.add_child(lap_label)
		$HUD/scoreboard/scores.add_child(score_list)
		for p_id in gamestate.players:
			var player_scores_list = VBoxContainer.new()
			print(gamestate.player_scores[p_id])
			for lap in gamestate.player_scores[p_id]:
				var score_label = Label.new()
				score_label.text = gamestate.player_scores[p_id][lap]
				print(lap)
				print(gamestate.player_scores[p_id][lap])
				player_scores_list.add_child(score_label)
			$HUD/scoreboard/scores.add_child(player_scores_list)
			print("---")
			#var score_label = Label.new()
			#score_list.add_child(score)
			#$HUD/scoreboard/scores.add_child(score_list)
		gamestate.update_scores(get_tree().get_network_unique_id(), gamestate.player_score)
		$HUD/scoreboard.show()
	else:
		# Display lap # / time on HUD
		$HUD/lap.text = str(gamestate.my_player.lap) + "/" + str(max_laps)

func refresh_scoreboard():
	var scoreboard = $HUD/scoreboard/scores
	free_child_nodes(scoreboard)
	var score_list = VBoxContainer.new()
	var my_name = Label.new()
	my_name.text = gamestate.player_name
	score_list.add_child(my_name)
	for lap_time in gamestate.my_player.lap_times:
		#print(lap_time)
		var lap_label = Label.new()
		lap_label.text = str(stepify(lap_time, 0.01))
		score_list.add_child(lap_label)
	$HUD/scoreboard/scores.add_child(score_list)
	for p_id in gamestate.players:
		var player_scores_list = VBoxContainer.new()
		print(gamestate.player_scores[p_id])
		for lap in gamestate.player_scores[p_id]:
			var score_label = Label.new()
			score_label.text = gamestate.player_scores[p_id][lap]
			print(lap)
			print(gamestate.player_scores[p_id][lap])
			player_scores_list.add_child(score_label)
		$HUD/scoreboard/scores.add_child(player_scores_list)
		print("---")
		var score_label = Label.new()

func update_scoreboard(body):
	# Get total time
	var total_time = body.lap_times[max_laps-1]
	# TODO: for player in group("players") type deal for > 2 player
	# Display scoreboard
	var score_string = ""
	var lap_string = ""
	for lap in range(max_laps):
		var lap_time
		if lap > 0:
			lap_time = float(body.lap_times[lap]) - float(body.lap_times[lap-1])
		else:
			lap_time = float(body.lap_times[lap])
		var last_lap = lap_string
		var last_score = score_string
		lap_string = last_lap + "\nLap " + str(lap + 1) + ": " 
		score_string = last_score + "\n" + str(stepify(lap_time, 0.01))
		if lap == max_laps - 1:
			last_score = score_string
			lap_string = lap_string + "\n\nTotal: "
			score_string = last_score + "\n\n" + str(stepify(total_time, 0.01))
	if body.get_name() == "Player1":
		$HUD/Scoreboard/Player1/Lap.text = lap_string
		$HUD/Scoreboard/Player1/Score.text = score_string
	if body.get_name() == "Player2":
		$HUD/Scoreboard/Player2/Lap.text = lap_string
		$HUD/Scoreboard/Player2/Score.text = score_string
	#$HUD/Scoreboard.update()
	#scorestring = "Lap 1: " + body.lap_times[0]		
	# Update other players' scores when they finish
	# or wait til they finish to display all scores