extends KinematicBody2D

onready var area = $Area2D
onready var collisionArea = $Area2D/CollisionTiles
var tilemap

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.1), "timeout")
	tilemap = get_tree().get_root().find_node("NavigationTile", true, false)
	if tilemap != null:
		tilemap.deleteTiles(global_position, collisionArea.shape.get_extents() )
#	print(collisionArea.global_position)
#	print(collisionArea.shape.get_extents())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_shape_entered(body_id, body, body_shape, local_shape):
#	print("nice")
#	print(area.get_overlapping_bodies())
	pass # Replace with function body.
