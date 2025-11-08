extends Node2D

@export var game_speed = 300
#width of the floor segments
@export var width = 330

func _physics_process(delta: float) -> void:
	#apply the game_speed to the floorsegments
	for segment in get_children():
		segment.position.x -= game_speed * delta
		
		#When a segment leaves the viewport, find the rightmost segmet and place it next to it
		if segment.position.x < 0:
			var rightmost = segment
			for s in get_children():
				if s.position.x > rightmost.position.x:
					rightmost = s
			segment.position.x = rightmost.position.x + width
