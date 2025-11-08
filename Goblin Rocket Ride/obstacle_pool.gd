extends Node2D

@export var houses_scene: PackedScene
@export var flying_scene: PackedScene
@export var cannon_scene: PackedScene

var obstacle_pool_size: int = 3

var ground_obstacle_pool = []
var air_obstacle_pool = []
var cannon_pool = []

func  _ready() -> void:
	#Prepare obstacles for the game
	for i in obstacle_pool_size:
		var obstacle = houses_scene.instantiate()
		obstacle.visible = false
		add_child(obstacle)
		ground_obstacle_pool.append(obstacle)
		
		var air_obstacle = flying_scene.instantiate()
		air_obstacle.visible = false
		add_child(air_obstacle)
		air_obstacle_pool.append(air_obstacle)
		
		var cannon_obstacle = cannon_scene.instantiate()
		cannon_obstacle. visible = false
		add_child(cannon_obstacle)
		cannon_pool.append(cannon_obstacle)

func get_ground_obstacle():
	#Pick obstacles from the pool
	for obstacle in ground_obstacle_pool:
		if obstacle.visible == false:
			return obstacle
	
	#Create new obstacles if the pool is empty
	var new_obstacle = houses_scene.instantiate()
	add_child(new_obstacle)
	ground_obstacle_pool.append(new_obstacle)
	return new_obstacle

func get_air_obstacle():
	#Pick obstacles from the pool
	for obstacle in air_obstacle_pool:
		if obstacle.visible == false:
			return obstacle
	
	#Create new obstacles if the pool is empty
	var new_obstacle = flying_scene.instantiate()
	add_child(new_obstacle)
	air_obstacle_pool.append(new_obstacle)
	return new_obstacle

func get_cannonball():
	#Pick cannonballs from the pool
	for cannonball in cannon_pool:
		if cannonball.visible == false:
			return cannonball
	
	var new_cannonball = cannon_scene.instantiate()
	add_child(new_cannonball)
	cannon_pool.append(new_cannonball)
	return new_cannonball
