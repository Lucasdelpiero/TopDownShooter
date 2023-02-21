extends MenuButtonClass

const SAVE_PATH = "user://save_json.json"



func _ready():
	pass # Replace with function body.

func save_game():
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	
	var global = GlobalControl
	
	
	var save_dict = {
		global = {
			max_score = global.max_score
		}
	}
#	print(save_dict.global.max_score)
	
	file.store_line(to_json(save_dict))


func load_game():
	var file = File.new()
	file.open(SAVE_PATH, File.READ)
	var save_dict = parse_json(file.get_line()) 
	
	var global = GlobalControl
	
	
	global.max_score = save_dict.global.max_score
	
#	print(save_dict.global.max_score)
	get_parent().updateInfo()
	
	









