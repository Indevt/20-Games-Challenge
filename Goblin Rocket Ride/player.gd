extends CharacterBody2D

#How fast the player can rise with the jetpack.
const RISE_VELOCITY = -300.0

#This variable exists to prevent emitting the signal "game_over" multiple times
var game_over_counter: bool = false

func _ready() -> void:
	SignalBus.restart.connect(restart_animation)

#The player should be able to rise by pressing a button and fall down when releasing it
func _physics_process(delta: float) -> void:
	# Add the gravity. Input condition is there because it helps with the AnimatedSprites
	if not is_on_floor() and Input.is_action_pressed("fly_up") == false:
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("fall")
   
	# Handle jetpack flying.
	if Input.is_action_pressed("fly_up"):
		velocity.y = move_toward(velocity.y, RISE_VELOCITY, 10)
		$AnimatedSprite2D.play("fly")
		$Sparks.emitting = true
	
	if is_on_floor():
		$AnimatedSprite2D.play("run")
	
	move_and_slide()

#If an obsctacle touches the player, he should vanish, and the game should end
func _on_area_2d_area_entered(_area: Area2D) -> void:
	die()

func die():
	if game_over_counter == false:
		hide()
		set_physics_process(false)
		SignalBus.emit_signal("game_over")
		game_over_counter = true

func restart_animation():
	$RestartAnimation.play("restart_animation")
