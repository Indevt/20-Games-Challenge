extends Node

#Loads the scenes, wich needs to be able to be added and removed during playtime
@export var ball_scene: PackedScene
@export var brain_scene: PackedScene
@export var straight_wall: PackedScene
@export var double_walls: PackedScene
@export var break_out: PackedScene

#Variables to store the instatiated scenes
var ball
var brain
var obstacle_scene
var obstacle

#Player scores
var score_player_one
var score_player_two

#Variable to prevent errors during _physics_process(), for the time when the players are not visible
var started = false

#Variable to store whether the game is going to be played alone or with two players
var oneplayer = true

#Sets the needed goals to win, default is 5
var wincondition = 5

#Sets the angle, in which the computerbrain differs from the ball, PI/32 for easy, PI/64 for medium, no difference for hard; defaulkt is easy
var difficulty = PI/32

# Called when the node enters the scene tree for the first time.
#Prepares the game. Every Nod xpect the Main menu is invisible, the game is paused, the ball is getting prepared und the players scores are reset
func _ready():
	ball = ball_scene.instantiate()
	score_player_one = 0
	score_player_two = 0
	$GUI.update_score(score_player_one, score_player_two)
	$Arena.hide()
	$Players.hide()
	$GUI/ArenaUI.hide()
	$GUI/ScoreScreen.hide()
	$GUI/PauseMenu.hide()
	$GUI/CountDown.hide()
	$GUI/Menu/TitleWall/Ball/AudioStreamPlayer.set_volume_db(-10)
	get_tree().paused = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float):
	#Checks, if the game is played alone
	if oneplayer == true:
		#Checks, if the game has started
		if started == true:
			#Checks, if there is a computer_brain instance in the game. If so, the PlayerTwo is set to match the height of the computer_brain.
			if is_instance_valid(brain) == true:
				if $Players/PlayerTwo.position.y > brain.position.y:
					$Players/PlayerTwo.direction.y = -1
	
				if $Players/PlayerTwo.position.y < brain.position.y:
					$Players/PlayerTwo.direction.y = 1
				
				if $Players/PlayerTwo.position.y == brain.position.y:
					$Players/PlayerTwo.direction = Vector2.ZERO
				
				#If the ball moves away from the PlayerTwo paddle, the computer_brain should be deleted
				if ball.direction.x < 0:
					brain.queue_free()
				
			#If the ball moves towards the PlayerTwo paddle and there is no computer_brain present, it spawns the computer_brain
			if ball.direction.x > 0 and is_instance_valid(brain) == false:
				spawn_brain()
	
	#Checks, if the game is played with two players. If so, allows the second player to movew the paddle with the "up" and "down" arrow keys
	if oneplayer == false:
		$Players/PlayerTwo.direction = Vector2.ZERO
		if Input.is_action_pressed("move_up_player_two"):
			$Players/PlayerTwo.direction.y = -1
	
		if Input.is_action_pressed("move_down_player_two"):
				$Players/PlayerTwo.direction.y = 1

#Adds the computer_brain instance to game. It is spawned at the balls position with the same speed, the direction differs dependent on the difficulty
func spawn_brain():
	brain = brain_scene.instantiate()
	brain.position = ball.position
	brain.direction = ball.direction.rotated(randf_range(-difficulty, difficulty))
	brain.speed = ball.speed
	add_child(brain)

#Called, when the ball enters the goal of PlayerOne. Updates the score and removes the ball.
func _on_goal_player_one_body_entered(_body):
	score_player_two += 1
	$GUI.update_score(score_player_one, score_player_two)
	ball.queue_free()
	#Calls to remove spawned obstacles
	remove_obstacles()
	
	#Checks, if the winning condition is met. If so, PlayerTwo wins, and the Label is adjusted to match the singleplayer or multiplayer game mode. 
	#Sets started to false to prevent errors in _physics_process()
	if score_player_two >= wincondition:
		started = false
		if oneplayer == true:
			win("Computer wins!")
		if oneplayer == false:
			win("Player Two wins!")
	
	#Prepares the ball, pauses the game and displays a countdown in the middle of the screen.
	else:
		$Players/ScoreSound.play()
		ball = ball_scene.instantiate()
		get_tree().paused = true
		$GUI.count_down()
		$DelayTimer.start()


#Called, when the ball enters the goal of PlayerTwo. Updates the score and removes the ball.
func _on_goal_player_two_body_entered(_body):
	#If the computer_brain is instantiated, it gets removed
	if is_instance_valid(brain) == true:
		brain.queue_free()
	
	score_player_one += 1
	$GUI.update_score(score_player_one, score_player_two)
	ball.queue_free()
	#Calls to remove spawned obstacles
	remove_obstacles()
	
	#Checks, if the winning condition is met. If so, PlayerOne wins.
	#Sets started to false to prevent errors in _physics_process()
	if score_player_one >= wincondition:
		started = false
		win("Player One wins!")
		
	#Prepares the ball, pauses the game and displays a countdown in the middle of the screen.
	else:
		$Players/ScoreSound.play()
		ball = ball_scene.instantiate()
		get_tree().paused = true
		$GUI.count_down()
		$DelayTimer.start()

#Displays the winner of the game
func win(winner):
	$Players/WinSound.play()
	$GUI/ScoreScreen.show()
	$GUI/ScoreScreen/Label.text = winner
	$EndTimer.start()

#Starts the game when the corresponding button is pressed in the Main menu. Hides the Main menu, mutes the Main menu ball, shows the arena and players, and starts a countdown.
func _on_gui_start_game():
	$GUI/Menu.hide()
	$Arena.show()
	$GUI/ArenaUI.show()
	$Players.show()
	$GUI.count_down()
	$DelayTimer.start()
	$GUI/Menu/TitleWall/Ball/AudioStreamPlayer.set_volume_db(-80)
	started = true

#Resets the game to it's inital state when the timer ends
func _on_end_timer_timeout():
	_ready()
	$GUI/Menu.show()

#When the Escape Button is pressed on the keyboards while the game is played, it pauses the game and shows the Pause menu
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and $GUI/PauseMenu.is_visible() == false and $GUI/Menu.is_visible() == false:
		get_tree().paused = true
		$GUI/PauseMenu.show()

#Resumes the game
func _on_gui_resume():
	get_tree().paused = false
	$GUI/PauseMenu.hide()

#Restarts the game with the currents settings
func _on_gui_restart():
	$GUI/PauseMenu.hide()
	score_player_one = 0
	score_player_two = 0
	$GUI.update_score(score_player_one, score_player_two)
	ball.queue_free()
	ball = ball_scene.instantiate()
	$GUI.count_down()
	$DelayTimer.start()

#Exits the game to the Main menu
func _on_gui_cancel():
	started = false
	ball.queue_free()
	_ready()
	$GUI/Menu.show()

#Unpauses the game and adds a ball, allows for obstacles to be spawned again
func _on_delay_timer_timeout():
	add_child(ball)
	$ObstacleSpawnTimer.start()
	get_tree().paused = false

#Sets the gamemode variable according to the selected option in the Main menu
func _on_gui_oneplayer():
	oneplayer = true
	$GUI/ArenaUI/DescriptionPlayerTwo.text = "Computer"
	
func _on_gui_twoplayers():
	oneplayer = false
	$GUI/ArenaUI/DescriptionPlayerTwo.text = "Player 2"

#Sets the goals needed to win according to the selected option in the Main menu
func _on_gui_win_condition_5():
	wincondition = 5

func _on_gui_win_condition_3():
	wincondition = 3

func _on_gui_win_condition_7():
	wincondition = 7

#Closes the game
func _on_gui_quit():
	get_tree().quit()

#Sets difficulty by setting the angle difference of the computer brain to the ball. Easy is PI/32, Medium is PI/64, Hard is no diffrence
func _on_gui_easy():
	difficulty = PI/32

func _on_gui_medium():
	difficulty = PI/64

func _on_gui_hard():
	difficulty = 0


#Spawns obstacles in the arena. Created an array of the possible scenes, chooses one randomly, and adds it to the game. Starts a timer to remove the obstacles after timeout
func _on_obstacle_spawn_timer_timeout():
	obstacle_scene = [straight_wall, double_walls, break_out].pick_random()
	obstacle = obstacle_scene.instantiate()
	add_child(obstacle)
	$ObstacleEndTimer.start()

#Removes the obstacles after timeout
func _on_obstacle_end_timer_timeout():
	obstacle.queue_free()
	$ObstacleSpawnTimer.start()

#Removes the obstacles safelty and prevents respawns.
func remove_obstacles():
	#If there is an obstacle in the arena, it gets removed and the timer for removal gets stopped.
	if is_instance_valid(obstacle) == true:
		obstacle.queue_free()
		$ObstacleEndTimer.stop()
	#If there is no obstacle in the arena, the spawntimer gets stopped to prevent further spawning
	if is_instance_valid(obstacle) == false:
		$ObstacleSpawnTimer.stop()
