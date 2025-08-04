extends Node2D

@export var debug_mode = false
@export var bug_spawn_distance = 300

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_spawn_bug_button_pressed():
	var bug_1 = preload("res://bug_1.tscn").instantiate()
	bug_1.position = ($Mech.position + 
		bug_spawn_distance*Vector2(1, 0).rotated(randf_range(0, 2*PI)))
	$BugsCollection.add_child(bug_1)
