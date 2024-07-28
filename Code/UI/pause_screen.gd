class_name PauseScreen extends Control

func _process(_delta):
	if GameMode.is_playing() and !visible and SAInput.start:
		SASignals.PauseGame.emit(true)
		SASignals.FocusedOnUi.emit(true)
		show()
	elif visible and (SAInput.ui_start or SAInput.ui_cancel):
		SASignals.PauseGame.emit(false)
		SASignals.FocusedOnUi.emit(false)
		hide()
		

