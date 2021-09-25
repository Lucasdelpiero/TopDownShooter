extends Area2D

export var amount = 12
export(String, "Rifle", "Pistol", "Shotgun") var type = "Rifle"
var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ammo_body_entered(body):
	body.grabAmmo(type, amount)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("Picked")
