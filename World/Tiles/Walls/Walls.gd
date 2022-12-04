tool
extends TileMap

var wallTiles = []
var navFloor 
var buildings = []

export(Color, RGBA) var grey = Color(0.364706, 0.352941, 0.352941)
export(Color, RGBA) var beige = Color(0.937255, 0.945098, 0.647059)
export(Color, RGBA) var blue = Color(0.258824, 0.290196, 0.545098)
onready var colors = {
	"grey" : grey,
	"beige" : beige,
	"blue" : blue,
}

# Called when the node enters the scene tree for the first time.

func _ready():
	wallTiles = get_used_cells() # Get an array of the cells of wall tiles
	navFloor = get_tree().get_root().find_node("NavigationTile", true, false) #Get tiles inside navigation2D
	for wall in wallTiles:     # Iterate in all the wall tiles
		navFloor.set_cellv(wall, -1)  # Deletes all the nav2D tiles that is in the same position of the walls
	
	## Get buildings tiles and changes theirs colors
	var tiles_ids = tile_set.get_tiles_ids()
	var tile_names := []
	for tile in tiles_ids:
		var name = tile_set.tile_get_name(tile)
		if name.begins_with("buildings"):
			tile_names.append(name)
			change_color(tile, name)

func change_color(tile, name):
	var color = "grey"
	var new_name = name.replace("buildings_","")
	print(name)
	print(new_name)
	if colors.has(new_name):
		color = new_name

	tile_set.tile_set_modulate(tile, colors[color] )
	pass

func _process(delta):
	if Engine.editor_hint:
		visible = false
