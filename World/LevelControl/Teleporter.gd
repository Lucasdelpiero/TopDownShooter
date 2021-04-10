extends Area2D

export(NodePath) var spawn = null
var pos

func _ready():
	pos = $Spawn.global_position
#	$Sprite.visible = false

func _on_Teleporter_body_entered(body):
	if spawn != null:
		body.global_position = get_node(spawn).pos
