extends Line2D

var max_length = 5
var point

func _ready():
	set_as_top_level(true)
	
func _process(_delta: float):
	point = get_parent().global_position
	add_point(point)
	if get_point_count() > max_length:
		remove_point(0)
