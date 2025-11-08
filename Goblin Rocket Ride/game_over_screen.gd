extends Control

#Connects the needed signals from the SignalBus with the functions
func _ready() -> void:
	SignalBus.update_score.connect(end_screen)

func end_screen(score, highscore):
	$SessionScore.text = "Your Score: " + str(score)
	$SessionHighscore.text = "Highscore: " + str(highscore)
