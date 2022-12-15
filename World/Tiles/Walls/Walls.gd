tool
extends TileMap

var wallTiles = []
var navFloor 
var buildings = []

export(Color, RGBA) var grey = Color(0.364706, 0.352941, 0.352941)
export(Color, RGBA) var beige = Color(0.937255, 0.945098, 0.647059)
export(Color, RGBA) var brown = Color(0.258824, 0.290196, 0.545098)
export(Color, RGBA) var orange = Color(0.956863, 0.772549, 0.560784)
export(Color, RGBA) var blue = Color(0.160784, 0.164706, 0.258824)
onready var colors = {
	"grey" : grey,
	"brown" : brown,
	"beige" : beige,
	"orange" : orange,
	"blue" : blue,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	wallTiles = get_used_cells() # Get an array of the cells of wall tiles
	navFloor = get_tree().get_root().find_node("NavigationTile", true, false) #Get tiles inside navigation2D
	if navFloor != null:
		for wall in wallTiles:     # Iterate in all the wall tiles
			navFloor.set_cellv(wall, -1)  # Deletes all the nav2D tiles that is in the same position of the walls
	
	## Get buildings tiles ids and do stuff
	var tiles_ids = tile_set.get_tiles_ids()
	var tile_names := []
	for tile in tiles_ids:
		var name = tile_set.tile_get_name(tile)
		# As will be only used with buildings tiles, the others get filtered
		if name.begins_with("buildings"):
			tile_names.append(name)
			change_color(tile, name)
			create_shape_and_bitmask(tile, name)

func change_color(tile, name):
	var color = "grey"
	var new_name = name.replace("buildings_","") # Not very usefull really
	if colors.has(new_name): 
		color = new_name

	tile_set.tile_set_modulate(tile, colors[color] )
	pass


## Gets the shape and bitmask from a base building and automatically applies
## all the data to get the new autotile working without manual work
func create_shape_and_bitmask(tile, name):
	var base = tile_set.find_tile_by_name("buildings_grey")
	var region = tile_set.tile_get_region(base)
	var subtile_size = tile_set.autotile_get_size(base)
	var tile_mode = tile_set.tile_get_tile_mode(base)
	var icon = tile_set.autotile_get_icon_coordinate(base)
	var shapes = tile_set.tile_get_shapes(base)
	var bitmask_mode = tile_set.autotile_get_bitmask_mode(base)
	var bitmask = tile_set.autotile_get_bitmask(base, Vector2(0.0, 0.0))
	
	if (name.begins_with("buildings_")):
		print("nice")
		tile_set.autotile_set_size(tile, subtile_size)
		tile_set.tile_set_tile_mode(tile, tile_mode)
		tile_set.autotile_set_icon_coordinate(tile, icon)
		tile_set.tile_set_shapes(tile, shapes)
		tile_set.autotile_set_bitmask_mode(tile, 1)
		var bitmasks = get_bitmask(region, subtile_size.x, base)
		set_bitmask(tile, bitmasks, region, subtile_size.x)
	
	pass

## The bitmask can only be obtained one by one so the tiles have to be
## iterated and stored in an array
func get_bitmask(region : Rect2, subtile_size, base):
	var bitmasks = []
	var columns = (region.size.x  / subtile_size)
	var rows = (region.size.y / subtile_size)
	
	for y in rows:
		for x in columns:
			bitmasks.append(tile_set.autotile_get_bitmask(base, Vector2(x, y)))
			pass
#	print(bitmasks)
	return bitmasks

## The bitmask can only be setted one by one so iteration is needed again
func set_bitmask(tile, array, rect, subtile_size):
	var columns = (rect.size.x  / subtile_size)
	var rows = (rect.size.y / subtile_size)
	
	
	for i in array.size():
		var x = i - columns * floor(i / columns)
		var y = floor(i / columns)
		var flag = array[i]
		
		tile_set.autotile_set_bitmask(tile, Vector2(x, y), flag)


func _process(delta):
#	if Engine.editor_hint:
#		visible = false
	pass
