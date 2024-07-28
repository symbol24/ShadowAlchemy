extends SAWorld

@onready var mm_control = %MMControl
@onready var credits = %Credits

@onready var play_button:TextureButton = %play_button
@onready var credits_button:TextureButton = %credits_button

func _ready():
	super._ready()
	play_button.pressed.connect(_press_play)
	credits_button.pressed.connect(_press_credits)
	SASignals.FocusedOnUi.emit(true)
	play_button.grab_focus()

func _process(_delta):
	if credits.visible:
		if SAInput.ui_cancel:
			credits.hide()
			mm_control.show()
			play_button.grab_focus()

func _press_play():
	SASignals.ToggleLoading.emit(true)
	SASignals.FocusedOnUi.emit(true)
	SASignals.LoadWorld.emit("world_01")

func _press_credits():
	mm_control.hide()
	credits.show()
