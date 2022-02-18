extends TileMap

var obstacles := []

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	obstacles = get_tree().get_nodes_in_group("obstacles")
	var tiles = get_used_cells()
	for i in obstacles.size():
		var localTiles = map_to_world(tiles[i])
		var globalTiles = to_global(localTiles)
		print("tiles: " + str(globalTiles))
		print("position car: " + str((obstacles[i].global_position)))
	
	pass # Replace with function body.

func deleteTiles(position : Vector2, extents : Vector2):
	var positionObject = Vector2(position.x - extents.y , position.y - extents.x  )
	var width = floor(extents.y / 128 * 2) # Width and Height are inverted in the collision shape
	var height = floor(extents.x / 128 * 2)
	positionObject /= 128
	for i in height:
		for o in width:
			set_cell(positionObject.x + o, positionObject.y + i, -1 )

	pass
