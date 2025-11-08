extends Control


#Connect the needed signals from the SignalBus to the functions
func _ready() -> void:
	SignalBus.update_score.connect(_on_update_score)

#Receives the score and displays it on the label
func _on_update_score(score, highscore) -> void:
	$Score.text = "Score: " + str(score)
	$Highscore.text = "Highscore: " + str(highscore)
