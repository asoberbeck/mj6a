extends CanvasLayer

var hide_options_buttons = true

func _on_options_button_pressed():
	hide_options_buttons = not hide_options_buttons
	if hide_options_buttons:
		$OptionsVBox/FullscreenButton.hide()
		$OptionsVBox/MainMenuButton.hide()
		$OptionsVBox/QuitButton.hide()
	else:
		$OptionsVBox/FullscreenButton.show()
		$OptionsVBox/MainMenuButton.show()
		$OptionsVBox/QuitButton.show()

func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	_on_options_button_pressed()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_debug_button_pressed():
	Mockup.debug_mode = not Mockup.debug_mode
	if Mockup.debug_mode:
		$DebugHBox/DebugLabel.show()
	else:
		$DebugHBox/DebugLabel.hide()
