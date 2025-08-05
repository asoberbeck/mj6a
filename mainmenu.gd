extends MarginContainer

func _new_game_pressed():
	get_tree().change_scene_to_file("res://mockup.tscn")
	print("new game pressed")
	
func _options_pressed():
	print("options pressed")
	
func _credits_pressed():
	print("credits pressed")
	
