extends TextureRect

export var noise_2 : NoiseTexture
var speed = 2.0
var direction = Vector2(1.5, 3.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	direction.normalized()
	var velocity = direction * speed * delta
	noise_2.noise_offset += Vector2(velocity)
	change_direction(delta)
	pass

func change_direction(delta):
	var a = rand_range(-1.0 * PI, 1.0 * PI)
	direction += Vector2(cos(a), sin(a)) * delta
	
