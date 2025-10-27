extends Control

#Signal to start the game in the Main menu
signal start_game

#Signal to resume the game in the Pause menu
signal resume

#Signal to restart the game in the Pause menu
signal restart

#Signal to get back to the Main menu in the Pause menu
signal cancel

#Signals to choose between playing vs the computer or vs another player locally in the Main menu
signal oneplayer
signal twoplayers

#Signals to set the needed scores to win, set in the Main menu
signal win_condition_5
signal win_condition_3
signal win_condition_7

#Signal to quit the game in the Main menu
signal quit

#Signals to adjust the difficulty in the Main menu
signal easy
signal medium
signal hard

#updates the score labels to match the player scores
func update_score(score_player_one, score_player_two):
	$ArenaUI/ScorePlayerOne.text = str(score_player_one)
	$ArenaUI/ScorePlayerTwo.text = str(score_player_two)

#Emits the signal to start the game in the Main menu
func _on_start_button_pressed():
	start_game.emit()

#Emit the signals corresponding to the buttons in the Pause menu
func _on_resume_button_pressed():
	resume.emit()
func _on_restart_button_pressed():
	restart.emit()
func _on_end_button_pressed():
	cancel.emit()

#Displays a count down from 3 in the middle of the screen
func count_down():
	$CountDown.show()
	$CountDown/CountDownLabel.text = "3"
	$CountDown/CountDownTimer.start()
	await $CountDown/CountDownTimer.timeout
	$CountDown/CountDownLabel.text = "2"
	$CountDown/CountDownTimer.start()
	await $CountDown/CountDownTimer.timeout
	$CountDown/CountDownLabel.text = "1"
	$CountDown/CountDownTimer.start()
	await $CountDown/CountDownTimer.timeout
	$CountDown.hide()
	

#Emit the signals corresponding to the buttons and options in the Main menu
func _on_option_button_item_selected(index: int):
	if index == 0:
		oneplayer.emit()
		$Menu/DifficultyButton.show()
	if index == 1:
		twoplayers.emit()
		$Menu/DifficultyButton.hide()

func _on_quit_button_pressed():
	quit.emit()

func _on_win_condition_button_item_selected(index: int):
	if index == 0:
		win_condition_5.emit()
	if index == 1:
		win_condition_3.emit()
	if index == 2:
		win_condition_7.emit()

func _on_difficulty_button_item_selected(index: int):
	if index == 0:
		easy.emit()
	if index == 1:
		medium.emit()
	if index == 2:
		hard.emit()
