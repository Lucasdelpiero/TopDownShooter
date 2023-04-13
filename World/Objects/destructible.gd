extends StaticBody2D

var GRID_SIZE = 128

var pos : Vector2 = Vector2(0.0, 0.0)
var nav : TileMap = null
var navToggle : Array = []


export(bool) var flipped = false
onready var sprite = $Sprite
var DoorParticles = preload("res://World/Objects/Decoration/DoorParticles.tscn")

func _on_Area2D_area_entered(_area):
	var doorParticles = DoorParticles.instance()
	get_tree().get_root().add_child(doorParticles)
	doorParticles.global_position = global_position
	doorParticles.rotation = rotation
	replaceWithNav()
	queue_free()

func _ready():
	navToggle = getNavGroup()
	initialize()
	if flipped:
		$Sprite.scale.x = -1 * $Sprite.scale.x

func initialize():
	if navToggle.empty():
		pos = getPos(self)
		nav = get_tree().get_root().find_node("NavigationTile", true, false) #Get tiles inside navigation2D
		nav.set_cellv(pos, -1)
	else:
		for el in navToggle:
			pos = getPos(el)
			nav = get_tree().get_root().find_node("NavigationTile", true, false) #Get tiles inside navigation2D
			nav.set_cellv(pos, -1)

func replaceWithNav():
	if (navToggle.empty()):
		nav.set_cellv(pos, 0)
	else:
		for el in navToggle:
			pos = getPos(el)
			nav.set_cellv(pos, 0)
	
	queue_free()

func getNavGroup():
	var temp = get_children()
	var newArr = []
	for el in temp:
		if(el.is_in_group("navToggle")):
			newArr.push_back(el)
	return newArr

func getPos(object : Object):
	return Vector2(floor(floor(object.global_position.x) / GRID_SIZE), floor(floor(object.global_position.y) / GRID_SIZE))
