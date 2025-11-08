extends Area2D

@export var game_speed = 300

#Prepares the textures
var house_one = preload("res://Art/Sprites/obstacles/GoblinRocketRide_houseone_scaled.png")
var house_two = preload("res://Art/Sprites/obstacles/GoblinRocketRide_housetwo_scaled.png")

#Assigns a random texture
func _ready() -> void:
	var variant = [house_one, house_two].pick_random()
	$Sprite2D.texture = variant

#Apply the game_speed to the obstacles
func _process(delta: float) -> void:
	position.x -= game_speed * delta

#Hide the obstacles if they leave the viewport
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	visible = false
