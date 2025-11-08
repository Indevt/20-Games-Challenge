extends Node

var save_path = "user://highscore.save"

func _ready() -> void:
	SignalBus.save_game.connect(_on_save)
	SignalBus.load_game.connect(_on_load)

func _on_save(highscore):
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(highscore)

func _on_load():
	var highest_score: int
	if FileAccess.file_exists(save_path):
		print("file found")
		var file = FileAccess.open(save_path, FileAccess.READ)
		highest_score = file.get_var()
	else:
		print("file not found")
		highest_score = 0
		
	SignalBus.emit_signal("loaded_highscore", highest_score)
