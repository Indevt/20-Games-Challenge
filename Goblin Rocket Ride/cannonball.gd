extends Area2D


@export var shooting_speed = 450

#Apply the game_speed to the obstacles
func _process(delta: float) -> void:
	position.x -= shooting_speed * delta

#Hide the obstacles if they leave the viewport
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	visible = false
