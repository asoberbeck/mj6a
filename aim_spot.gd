extends Node2D

var target = Vector2()

func _physics_process(delta):
	target = get_global_mouse_position()
	position = target
