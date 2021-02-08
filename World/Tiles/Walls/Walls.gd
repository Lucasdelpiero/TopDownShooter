extends TileMap

var wallTiles = []
var navFloor 

# Called when the node enters the scene tree for the first time.
func _ready():
	wallTiles = get_used_cells() # Get an array of the cells of wall tiles
	navFloor = get_tree().get_root().find_node("FloorLevelTile", true, false) #Get tiles inside navigation2D
	for wall in wallTiles:     # Iterate in all the wall tiles
		navFloor.set_cellv(wall, -1)  # Deletes all the nav2D tiles that is in the same position of the walls
