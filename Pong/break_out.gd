extends RigidBody2D

#Destroys itself; is called, when the ball collides with it
func break_wall():
	queue_free()
