extends Node

var list = {} # Weapon types for every weapon

var image = { #Images for the weapons
	"Pistol": "res://World/Objects/128x72.png",
	"Rifle": "res://World/Objects/Weapons/256rifle.png",
	"Shotgun":"res://World/Objects/Weapons/256shotgun.png",
	
	"default": "res://World/Objects/Weapons/256rifle.png",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var weapons = get_children()
	for weapon in weapons:
		list[weapon.name] = weapon.type

func getImage(aWeapon):
	return image[getType(aWeapon)]

func getType(weapon):
	if list.has(weapon):
		return list[weapon]
	return "default"
