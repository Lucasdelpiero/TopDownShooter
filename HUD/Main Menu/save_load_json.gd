extends Node

const SAVE_PATH = "user://save_json.json"



func _ready():
	pass # Replace with function body.

func save_game():
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	
	var global = GlobalControl
	print(global.max_scores)
	
	var save_dict = {
		global = {
			max_scores = global.max_scores
		}
	}
	
	file.store_line(to_json(save_dict))


func load_game():
	var file = File.new()
	file.open(SAVE_PATH, File.READ)
	var save_dict = parse_json(file.get_line()) 
	
	var global = GlobalControl
	
	global.max_scores = save_dict.global.max_scores
	
	get_parent().test()
	










