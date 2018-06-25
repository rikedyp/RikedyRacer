extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var ip
var current_scene
var master_ready = false
var slave_ready = false

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
