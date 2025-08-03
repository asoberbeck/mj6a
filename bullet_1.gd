extends Area2D

@export var speed = 500
@export var ttl = 1.0
var age = 0

func _physics_process(delta):
	age += delta
	if age > ttl:
		queue_free()
		return
	position += Vector2(1, 0).rotated(global_rotation)*speed*delta
