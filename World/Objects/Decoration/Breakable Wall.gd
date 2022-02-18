extends StaticBody2D

var pos : Vector2 = Vector2(0.0, 0.0)
var nav : TileMap = null

func _ready():
	pos = Vector2(int(global_position.x / 128), int(global_position.y / 128))
	nav = get_tree().get_root().find_node("NavigationTile", true, false) #Get tiles inside navigation2D
	nav.set_cellv(pos, -1)
	
	pass


func _on_Area2D_area_entered(area):
	# Animations 
	nav.set_cellv(pos, 0)
	queue_free()
	pass # Replace with function body.
