extends Node

var puntos: int = 0
var highscore: int = 0

const SAVE_PATH = "user://savegame.save"

func save_data():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data = {
		"highscore": highscore
	}
	file.store_var(data)
	file.close()

func load_data():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()
		highscore = data.get("highscore", 0)



func _ready():
	load_data()
