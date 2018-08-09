extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal shotgun_upgrade
signal mg_upgrade
signal laser_upgrade
signal pistol_upgrade

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_x_pressed():
	hide()


func _on_shotgun_upgrade_pressed():
	#print(gamestate.see_children(get_parent()))
	print(get_parent().get_name())
	get_parent().get_node("animated_sprite").set_animation("level2")
	$shotgun/shotgun_upgrade/animation.set_animation("level3")
	get_parent().set_level("level2")
	#print(get_parent().get_node("animation").set_animation("level2"))
	emit_signal("shotgun_upgrade")
	hide()
	pass # replace with function body

func _on_upgrade_pressed():
	#get_parent().get_node("animated_sprite").set_animation("level2")
	#print(get_parent().get_name())
	get_parent().upgrade_level()
	hide()
	
func _on_mg_upgrade_pressed():
	get_parent()
	pass # replace with function body
