extends Area2D

export var amount = 12
export var type = "rifle"
#var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ammo_body_entered(body):
	body.grabAmmo(type, amount)
	queue_free()
