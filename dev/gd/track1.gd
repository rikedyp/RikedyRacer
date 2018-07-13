extends Node2D
export (int) var max_laps = 2
export (int) var countdown = 3
export (float) var top_speed
export (float) var grass_speed
var camera
var dir

func _ready():
	# Connect checkpoint signals
	for checkpoint in $checkpoints.get_children():
		checkpoint.connect("lap_passed", self, "lap")
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
	gamestate.my_player.lap += 1
	# Display lap # / time on HUD
	$HUD/lap.text = str(gamestate.my_player.lap) + "/" + str(max_laps)

func _on_0_body_entered_checkpoint(area, body):
	print(area)
	print(body)
	pass # replace with function body
