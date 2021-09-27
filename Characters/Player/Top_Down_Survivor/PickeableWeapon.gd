extends Sprite

var weaponList = {
	"Rifle" : "res://Characters/Player/Top_Down_Survivor/rifle/Rifle.tscn",
	"Shotgun" : "res://Characters/Player/Top_Down_Survivor/shotgun/Shotgun.tscn",
	"Pistol" :"res://Characters/Player/Top_Down_Survivor/pistol/Pistol.tscn",
	"SuperRifle" : "res://Characters/Player/Top_Down_Survivor/rifle/SuperRifle.tscn",
	"SuperShotgun" : "res://Characters/Player/Top_Down_Survivor/shotgun/SuperShotgun.tscn",
}
export(String, "Rifle", "Shotgun", "Pistol", "SuperRifle", "SuperShotgun") var weapon = "Rifle"

var weaponPath 

signal pickWeapon(path)

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponPath = weaponList[weapon]
	var Weapon = load(weaponPath)
	var newWeapon = Weapon.instance()
	call_deferred("add_child", newWeapon)

func _on_Area2D_body_entered(body):
	connect("pickWeapon", body, "grabWeapon")
	emit_signal("pickWeapon", weaponPath)
	disconnect("pickWeapon", body, "grabWeapon")
