extends Node2D

#The playerscore, initially zero
var score: int = 0
#Highscore
var highscore: int = 0

#Array of possible spawnlocations for the obstacles
var spawn_locations = [$GroundSpawnPosition, $AirSpawnPositionOne]

#Connect the needed signals from the SignalBus on initializing
func _ready() -> void:
	SignalBus.start_game.connect(_on_start_game)
	SignalBus.game_over.connect(_on_game_over)
	SignalBus.loaded_highscore.connect(load_highscore)
	initialize()

#Prepares the game for a new start
func initialize():
	SignalBus.load_game.emit()
	$MainMenu.show()
	$GameOverScreen.hide()
	$UI.hide()
	$Player.show()
	$Player.set_physics_process(true)
	$Player.position = Vector2(56, 288)
	$Player.velocity = Vector2.ZERO
	$Player.game_over_counter = false
	score = 0
	SignalBus.emit_signal("update_score", score, highscore)

#Loads the highscore from the savefile
func load_highscore(highest_score):
	highscore = highest_score

#Spawn obstacles on random spawnlocations
#Type of obstacle is dependent on the spawnlocation
func _on_obstacle_spawn_timer_timeout() -> void:
	var obstacle
	var spawn_loc = [$GroundSpawnPosition, $AirSpawnPositionOne, $AirSpawnPositionTwo].pick_random()
	
	if spawn_loc == $GroundSpawnPosition:
		obstacle = $ObstaclePool.get_ground_obstacle()
		obstacle.position = spawn_loc.position
		obstacle.visible = true
	
	if spawn_loc == $AirSpawnPositionOne or spawn_loc == $AirSpawnPositionTwo:
		obstacle = $ObstaclePool.get_air_obstacle()
		obstacle.position = spawn_loc.position
		obstacle.visible = true
	

#The score should rise over time and be updated in the UI
func _on_score_timer_timeout() -> void:
	score += 1
	if score > highscore:
		highscore = score
	SignalBus.emit_signal("update_score", score, highscore)

#Starts the game by starting the spawn- and scoretimers and hiding the MainMenu 
func _on_start_game() -> void:
	$ObstacleSpawnTimer.start()
	$CannonTimer.start()
	$ScoreTimer.start()
	$UI.show()
	$MainMenu.hide()
	$TitleMusic.play()

#Show the GameOverScreen after the player vanishes, starts the EndTimer before initializing the game. Saves the highscore
func _on_game_over() -> void:
	$SoundsAndMusic/Explosion.play()
	$Explosion.position = $Player.position
	$Explosion.emitting = true
	$ObstacleSpawnTimer.stop()
	$CannonTimer.stop()
	$ScoreTimer.stop()
	$UI.hide()
	$GameOverScreen.show()
	SignalBus.emit_signal("save_game", highscore)
	$EndTimer.start()
	$TitleMusic.stop()
	

#Lets the game initiaize when the timer runs out
func _on_end_timer_timeout() -> void:
	$RestartTimer.start()
	$Player.show()
	$GameOverScreen.hide()
	SignalBus.emit_signal("restart")

#Spawns a cannonball and randomizes the spawntimer
func _on_cannon_timer_timeout() -> void:
	var rnd_time = randi_range(1, 4)
	$CannonTimer.wait_time = rnd_time
	
	var cannonball = $ObstaclePool.get_cannonball()
	cannonball.visible = true
	cannonball.position = Vector2($GroundSpawnPosition.position.x, $Player.position.y)
	$SoundsAndMusic/CannonShot.set_pitch_scale(randf_range(0.9, 1.1))
	$SoundsAndMusic/CannonShot.play()
	


func _on_restart_timer_timeout() -> void:
	initialize()
