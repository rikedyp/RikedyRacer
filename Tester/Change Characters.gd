extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var toggle = 0
var charcounter = 1
var textcounter = 0
onready var tie = get_node("GUIlayer/GUI/dialogue-bubble/TextInterfaceEngine")
onready var char_list = [get_node("Ranger"),get_node("Player"),get_node("Pirate")]
onready var cam_list = [get_node("Ranger/Camera"),get_node("Player/Camera"),get_node("Pirate/Camera")]
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	tie.set_color(Color(0,0,0))
	pass

func _input(event):
	pass
#	if Input.is_action_just_pressed("ui_accept"):
#		print("accept")
#		if textcounter == 0:
#			tie.buff_clear()
#			tie.buff_text("I can't feel my legs...", 0.05)
#			textcounter += 1
#		elif textcounter == 1:
#			tie.buff_text("... well i'm certainly not in control of them...", 0.05)
#			textcounter += 1
#		elif textcounter == 2:
#			tie.buff_clear()
#			textcounter = 0
#		tie.set_state(tie.STATE_OUTPUT)

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_click"):
		print('click')			
		
	# Input for GUI (maybe nonplayer objects too)
	# if input isn't consumed here it passes to _unhandled_input
	if Input.is_action_just_pressed("ui_page_down"):
		var charprev = charcounter - 1
		if charprev < 0:
			charprev = len(char_list) - 1
		var charnext = charcounter + 1
		if charnext > len(char_list) - 1:
			charnext = 0
		char_list[charprev].active = false
		char_list[charnext].active = false
		char_list[charcounter].active = true
		#cam_list[charcounter].make_current()
		#char_list[charcounter].camera.make_current()
		charcounter += 1
		if charcounter > len(char_list)-1:
			charcounter = 0
		# escape key to quit:
	if Input.is_action_just_pressed("ui_pause"):
		get_tree().quit()

func _process(delta):
	pass

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass







func _on_Ranger_area_shape_entered(area_id, area, area_shape, self_shape):
	print('Ranger area entered')
	pass # replace with function body


func _on_input_enter(s):
	print("input_entered")
	pass

func _on_Pirate_area_shape_entered(area_id, area, area_shape, self_shape):
	get_node("Pirate/interrogation-point").show()
	$Pirate.nearby = true

func _on_Pirate_area_shape_exited(area_id, area, area_shape, self_shape):
	$Pirate.nearby = false
	get_node("Pirate/interrogation-point").hide()
	pass # replace with function body
