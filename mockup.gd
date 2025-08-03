extends Node2D

@export var debug_mode = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
