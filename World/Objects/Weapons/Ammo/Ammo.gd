extends Area2D

export var amount = 12
export(String, "Rifle", "Pistol", "Shotgun") var type = "Rifle"
export(Texture) var pistol_ammo
export(Texture) var rifle_ammo
export(Texture) var shotgun_ammo
var damage = 0
onready var sprite : Sprite = $Sprite

# Called when the node enters the scene tree for the first time.
func _ready():
	if type == "Rifle":
		sprite.texture = rifle_ammo
	if type == "Shotgun":
		sprite.texture = shotgun_ammo
	if type == "Pistol":
		sprite.texture = pistol_ammo


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ammo_body_entered(body):
	body.grabAmmo(type, amount)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("Picked")
