extends Node2D

func _ready():
	randomize()
	set_camera_limits()

func set_camera_limits():
	var map_size = $TileMap.get_used_rect()
	var cell_size = $TileMap.cell_size
	$Player/Camera2D.limit_left = map_size.position.x * cell_size.x
	$Player/Camera2D.limit_top = map_size.position.y * cell_size.y
	$Player/Camera2D.limit_right = map_size.end.x * cell_size.x
	$Player/Camera2D.limit_bottom = map_size.end.y * cell_size.y