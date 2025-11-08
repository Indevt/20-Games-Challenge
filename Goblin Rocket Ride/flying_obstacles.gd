extends Area2D

@export var game_speed = 300

func _ready():
	var variant = [1, 2].pick_random()
	
	if variant == 1:
		$AnimatedSprite2D.set_animation("Dragon")
	
	if variant == 2:
		$AnimatedSprite2D.set_animation("Ship")
	
#Apply the game_speed to the obstacles
func _process(delta: float) -> void:
	position.x -= game_speed * delta
	
	$AnimatedSprite2D.play()

#Hide the obstacles if they leave the viewport
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	visible = false
