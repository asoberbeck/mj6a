extends Area2D

@export var speed = 500

func _physics_process(delta):
	position += Vector2(1, 0).rotated(global_rotation)*speed*delta
