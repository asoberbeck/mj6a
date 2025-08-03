extends VBoxContainer

var hide_buttons = true

func _on_options_button_pressed():
	hide_buttons = not hide_buttons
	if hide_buttons:
		$FullscreenButton.hide()
		$MainMenuButton.hide()
		$QuitButton.hide()
	else:
		$FullscreenButton.show()
		$MainMenuButton.show()
		$QuitButton.show()

func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	_on_options_button_pressed()

func _on_quit_button_pressed():
	get_tree().quit()
