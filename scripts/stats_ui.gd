extends CanvasLayer

@onready var fps_label = $FPSLabel
@onready var coords_label = $CoordsLabel

func _process(delta):
	update_fps()
	update_coords()

func update_fps():
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())

func update_coords():
	var player_path = "../Player"
	if has_node(player_path):
		var player = get_node(player_path)
		var player_pos = player.global_transform.origin
		coords_label.text = "Pos: " + vector3_to_string(player_pos)
	else:
		coords_label.text = "Pos: Loading..."

func vector3_to_string(vector):
	return "(%.0f, %.0f, %.0f)" % [vector.x, vector.y, vector.z]
