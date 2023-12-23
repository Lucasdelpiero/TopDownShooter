extends Node2D
### Uses the "NavToggle" scenes to add points in the tiles to delete the 
### navigation tiles to block pathing and can be added it back once the object is destroyed

### LIMITATIONS : -The objects has to be placed exactly at in a grid of 128 px to work correctly, if is offseted even for a few pixels the navigation wont work correctly
### -The points added for each tile to be deleted/re-added have to be childrens of the object in this script, the points can be used children of a single node2D with just this
### script added for easy organization
var GRID_SIZE = 128 # Grid size used in the game

var pos : Vector2 = Vector2(0.0, 0.0) # Initialized position to delete navigation tile
var nav : TileMap = null # Navigation tileset used
var navToggle : Array = [] # Points used to track the tiles to delete / re-add


func _ready():
	navToggle = getNavGroup()
	initialize()

# Delete the navigation tiles in the the selected points or by default on the object with this script
func initialize():
	if navToggle.empty():
		pos = getPos(self)
		nav = get_tree().get_root().find_node("NavigationTile", true, false) #Get tiles inside navigation2D
		if nav == null: 
			return
		nav.set_cellv(pos, -1)
	else:
		for el in navToggle:
			pos = getPos(el)
			nav = get_tree().get_root().find_node("NavigationTile", true, false) #Get tiles inside navigation2D
			if nav == null:
				return
			nav.set_cellv(pos, -1)

# Re-add navigation tiles in the tiles selected poionts or by default on the object with this script
func replaceWithNav():
	if (navToggle.empty()):
		nav.set_cellv(pos, 0)
	else:
		for el in navToggle:
			pos = getPos(el)
			nav.set_cellv(pos, 0)

# Get the group of objects used to toggle on-off the navigation tiles
func getNavGroup():
	var temp = get_children()
	var newArr = []
	for el in temp:
		if(el.is_in_group("navToggle")):
			newArr.push_back(el)
	return newArr

# Get position from the point selected in the navigation grid
func getPos(object : Object):
	return Vector2(floor(floor(object.global_position.x) / GRID_SIZE), floor(floor(object.global_position.y) / GRID_SIZE))
#	return Vector2(int(object.global_position.x / GRID_SIZE), int(object.global_position.y / GRID_SIZE))
