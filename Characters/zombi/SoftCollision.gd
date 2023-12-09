extends Area2D

func is_colliding():
	var areas = get_overlapping_areas() #return array
	return areas.size() > 0

func get_push_vector():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
#	if is_colliding():
#		var area = areas[0]
#		push_vector = area.global_position.direction_to(global_position)
#		push_vector = push_vector.normalized()
	for area in areas:
		var new_push = area.global_position.direction_to(global_position)
		new_push = new_push.normalized()
		push_vector += new_push
	return push_vector
