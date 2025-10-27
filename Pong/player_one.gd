extends CharacterBody2D

#The players speed
@export var speed = 300


#Allows the player to move up and down by pressind the keys "w" and "s". Also prevents the player to leave the arena.
func _physics_process(_delta: float):
	#Direction, in which the player moves
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_up_player_one"):
		direction.y = -1
	
	if Input.is_action_pressed("move_down_player_one"):
		direction.y = 1
	
	#Multiplies the players speed and direction in order to get the corresponding movement vector
	velocity.y = speed * direction.y
	
	move_and_slide()
