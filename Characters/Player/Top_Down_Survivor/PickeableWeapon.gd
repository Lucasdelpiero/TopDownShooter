extends Sprite

var weaponList = {
	"rifle" : "res://Characters/Player/Top_Down_Survivor/rifle/Rifle.tscn",
	"shotgun" : "res://Characters/Player/Top_Down_Survivor/shotgun/Shotgun.tscn",
	"pistol" :"res://Characters/Player/Top_Down_Survivor/pistol/Pistol.tscn",
	"superRifle" : "res://Characters/Player/Top_Down_Survivor/rifle/SuperRifle.tscn",
}
export(String, "rifle", "shotgun", "pistol", "superRifle") var weapon = "rifle"

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
