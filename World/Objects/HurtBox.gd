extends Area2D

signal invincibility_started
signal invincibility_ended

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

var invincible = false setget set_invincible

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false
	get_parent().modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_HurtBox_invincibility_started():
	collisionShape.set_deferred("disabled", true)

func _on_HurtBox_invincibility_ended():
	collisionShape.disabled = false
