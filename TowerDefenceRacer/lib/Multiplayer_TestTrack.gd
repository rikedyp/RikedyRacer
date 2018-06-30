extends Node2D
export (int) var max_laps = 2
var camera
var dir
var countdown = 3
var ActivePlayer

func _ready():
	#connect("Ready", self, "new_game")
	$HUD/Lap.text = "Lap: " + "1/" + str(max_laps)
	# Change player 2 car colour
	# TODO: Let players choose car colour in the lobby
	$Player2/AnimatedSprite.animation = "Black"
	if not is_network_master(): # why this?
		# Disable players during countdown
		for player in get_tree().get_nodes_in_group("players"):
			print(player.get_name() + " Ready.")
			player.set_frame(2)
			player.ACTIVE = false
			#player.AnimatedSprite.set_frame(2)
	# By default, all nodes in server inherit from master,
	# while all nodes in clients inherit from slave.
	if (get_tree().is_network_server()):
		# TODO: How to generalise for > 2 player?
		#If in the server, give control of player 2 to the other peer.
		#This function is tree recursive by default.
		ActivePlayer = get_node("Player1")
		get_node("Player2").set_network_master(get_tree().get_network_connected_peers()[0])
		camera = get_node("Player1/Camera")
		camera._set_current(true)
	else:
		#If in the client, give control of player 2 to itself.
		#This function is tree recursive by default.
		get_node("Player2").set_network_master(get_tree().get_network_unique_id())
		camera = get_node("Player2/Camera")
		ActivePlayer = get_node("Player2")
		camera._set_current(true)
	print("unique id: ",get_tree().get_network_unique_id())
	# might need to alter ActivePlayer method or delete
	# Get both players to confirm ready here
	$HUD/CDBG.show()
	$HUD/Countdown.show()
	$HUD/Countdown.text = str(countdown)
	$HUD/Timer.start()

#func new_game():
#	#This starts the game upon connection.
#	print("new game!!!")
#	var stage = load("res://Scenes/Multiplayer_TestTrack.tscn").instance()
#	stage.connect("game_finished",self,"_end_game",[],CONNECT_DEFERRED) # connect deferred so we can safely erase it from the callback
#	get_tree().get_root().add_child(stage)
#	hide()
#	pass

func _process(delta):
#	for player in get_tree().get_nodes_in_group("players"):
#		if player.lap <
	if ActivePlayer.lap < max_laps + 1: 
		$HUD/Clock.text = str(stepify(ActivePlayer.time,0.01))
	pass

func _on_PitStop_body_entered(body):
	if body.get_name() == ActivePlayer.get_name() and is_network_master():
		$TowerCam1.in_pitstop = true
		# Change Player1 to TowerEdit mode (player1 always master
		# TODO: More elegant solution which scales to >2 and/or flexible no. of players
		$TowerCam1/Camera.make_current()
	elif body.get_name() == ActivePlayer.get_name() and not is_network_master():
		$TowerCam2.in_pitstop = true
		# Change Player2 to TowerEdit mode
		$TowerCam2/Camera.make_current()

func _on_PitStop_body_exited(body):
	if body.get_name() == "Player1" and get_tree().is_network_server():
		$TowerCam1.in_pitstop = false
		$Player1/Camera.make_current()
		# Change Player1 to Racing mode
	elif body.get_name() == "Player2" and not get_tree().is_network_server():
		$TowerCam2.in_pitstop = false
		# Change Player2 to Racing mode
		$Player2/Camera.make_current()

func _on_TheLine_body_entered(body):
	if body.velocity.y < 0:
		dir = 1
	else:
		dir = -1

func _on_TheLine_body_exited(body):
	var lapstring
	# TODO: Figure out methods for any number (flexible number) of players
	if dir == 1 and body.velocity.y < 0:
		# This player going correct direction
		body.lap += 1
		if body.lap > 1:
			# Save lap time
			body.lap_times.append(body.time)
			#print($HUD/Clock.text)
	elif dir == -1 and body.velocity.y > 0:
		# This player going wrong direction
		body.lap -= 1
	if body.lap > max_laps:
		body.ACTIVE = false
		lapstring = "Lap: " + str(max_laps) + "/" + str(max_laps) + " FINISHED"
		#rpc("update_scores", body)
		update_scores(body)
	else:
		lapstring = "Lap: " + str(body.lap) + "/" + str(max_laps)
	if body.get_name() == ActivePlayer.get_name():
		$HUD/Lap.text = lapstring
		if body.lap > max_laps:
			$HUD/Scoreboard.show()
			#$HUD/AgainButton.show()

func update_scores(body):
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

func show_lobby():
	var lobby = load("res://Scenes/Lobby.tscn").instance()
	get_tree().get_root().add_child(lobby)

func _on_HUD_countdown_timeout():
	if countdown > -1:
		countdown -= 1
		if countdown == 0:
			ActivePlayer.ACTIVE = true
			$HUD/Countdown.hide()
			$HUD/CDBG.hide()
		$HUD/Countdown.text = str(countdown)
	else:
		$HUD/Timer.stop()

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

func _on_Grass_body_entered(body):
	pass # replace with function body
