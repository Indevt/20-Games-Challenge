extends RigidBody2D

#Movement speed of the ball
@export var speed = 10

#Array to give the ball four possible movement directions at the start of the game
var start_directions = [-1, 1]

#Vector to control the movement direction
var direction = Vector2.ZERO

# Called when the node enters the scene tree for the first time. Assigns the initial movement direction.
func _ready():
	direction = Vector2(start_directions.pick_random(), start_directions.pick_random()).normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#If the ball collides, it bounces off the object in the same angle it hit it.
func _physics_process(_delta: float):
	var collision = move_and_collide(direction * speed)
	
	if collision:
		direction = direction.bounce(collision.get_normal())
		$AudioStreamPlayer.play()
		
		#If the object is a player, the angle gets randomly variied for more fun
		if collision.get_collider().get_class() == "CharacterBody2D":
			direction = direction.rotated(randf_range(-PI/8, PI/8))
			speed = randf_range(10.0, 10.5)
		
		#If the object is a break-out type obstacle, the object is told to destroy itself
		if collision.get_collider().get_class() == "RigidBody2D":
			collision.get_collider().break_wall()
