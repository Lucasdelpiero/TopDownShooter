extends Area2D

# Node that send signals to their children so that they perform 
# a default action (activate)

var childrens : Array
var used = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var nodes = get_children()
	for i in nodes.size():
		if not nodes[i].is_in_group("ignore"):
			childrens.append(nodes[i])
#	print(childrens)


func _on_Activator_body_exited(_body):
	if not used:
		activate()
		used = true
		
func activate():
	for i in childrens.size():
		childrens[i].activate()
