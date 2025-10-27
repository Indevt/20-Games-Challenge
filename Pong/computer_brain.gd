extends RigidBody2D
#A invisible ball, which the computer follows instead of the ball, to make the computer less than perfect

#Movement speed of the ball
var speed = 10
var direction = Vector2.ZERO

#If the ball collides, it bounces off the object in the same angle it hit it.
func _physics_process(_delta: float):
	var collision = move_and_collide(direction * speed)
	
	if collision:
		direction = direction.bounce(collision.get_normal())
