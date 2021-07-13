extends Sprite

#export(Resource) var WeaponP
export(PackedScene) var Weapon
var weaponPath

signal pickWeapon(path)

# Called when the node enters the scene tree for the first time.
func _ready():
	weaponPath = Weapon.get_path()
	print(weaponPath)
	var weapon = Weapon.instance()
	call_deferred("add_child", weapon)

func _on_Area2D_body_entered(body):
	connect("pickWeapon", body, "grabWeapon")
	emit_signal("pickWeapon", weaponPath)
