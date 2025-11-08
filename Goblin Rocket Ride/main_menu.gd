extends Control

#Connects the signals from the SignalBus to the corresponding functions
func _ready() -> void:
	SignalBus.loaded_highscore.connect(set_highscore)

#Allows the player to start the game by pressing "Enter"
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("start_game") and visible == true:
		SignalBus.start_game.emit()

#Displays the highset archieved highscore
func set_highscore(highest_score):
	$Highscore.text = "Highscore: " + str(highest_score)
