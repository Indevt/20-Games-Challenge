extends CharacterBody2D

#The players speed
@export var speed = 300

#The direction is found the to prevent errors when the computer controls the player in the Main script
var direction = Vector2.ZERO


#Most of the function has moved to the main script to prevent errors and to be able to respond to other scenes easier
func _physics_process(_delta: float):
	#Multiplies the players speed and direction in order to get the corresponding movement vector
	velocity.y = speed * direction.y
	
	move_and_slide()
