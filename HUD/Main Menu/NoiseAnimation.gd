extends TextureRect

export(float, 0.0, 100, 5.0) var offset_speed = 50.0
export(float, 0, 360, 5.0) var offset_angle = 60.0
export(int, 0, 180, 15) var max_change_in_angle = 15

var offset_x : float = 0.0
var offset_y : float = 0.0


onready var tween = $Tween
onready var timer = $Timer


func _ready():
	randomize()

func _process(delta):
	var angle = deg2rad(offset_angle)
	offset_x +=   (offset_speed * cos(angle)) * delta
	offset_y +=  (offset_speed * sin(angle)) * delta
	var newOffset = Vector2(offset_x, offset_y)
	texture.set("noise_offset", newOffset)

func change_angle():
	var new_angle = offset_angle + (randi() % max_change_in_angle) - randi() % max_change_in_angle 
	tween.interpolate_property(self, "offset_angle", offset_angle, new_angle, 4, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()



func _on_Timer_timeout():
	change_angle()
