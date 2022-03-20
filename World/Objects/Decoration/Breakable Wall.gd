extends StaticBody2D

var pos : Vector2 = Vector2(0.0, 0.0)
var nav : TileMap = null

# Need to get the amount of cells to delete and the direction

func _ready():
	initialize()



func _on_Area2D_area_entered(area):
	# Animations 
	replaceWithNav()
	pass # Replace with function body.

func initialize():
	pos = Vector2(int(global_position.x / 128), int(global_position.y / 128))
	nav = get_tree().get_root().find_node("NavigationTile", true, false) #Get tiles inside navigation2D
	nav.set_cellv(pos, -1)

func replaceWithNav():
	nav.set_cellv(pos, 0)
	queue_free()
