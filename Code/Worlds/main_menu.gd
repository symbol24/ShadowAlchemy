extends SAWorld

const MAIN_MENU_MUSIC = preload("res://Data/Audio/Files/main_menu_music.tres")

@onready var mm_control = %MMControl
@onready var credits = %Credits
@onready var scroll:ScrollContainer = %scroll

@onready var play_button:TextureButton = %play_button
@onready var credits_button:TextureButton = %credits_button

var is_scrolling := false
var apply_multi := false
var speed := 100.0
var multiplyer := 3.0

func _ready():
	super._ready()
	if GameMode.is_playing():
		SASignals.PauseGame.emit(true)
	play_button.pressed.connect(_press_play)
	credits_button.pressed.connect(_press_credits)
	SASignals.FocusedOnUi.emit(true)
	play_button.grab_focus()
	Audio.play(MAIN_MENU_MUSIC)

func _process(_delta):
	if credits.visible:
		if is_scrolling:
			var direction = 1
			apply_multi = false
			if SAInput.ui_left_stick_up_down >= 0.5:
				direction = 1
				apply_multi = true
			elif SAInput.ui_left_stick_up_down <= -0.5:
				direction = -1
				apply_multi = true
			var mult = 0.8 if !apply_multi else multiplyer
			scroll.scroll_vertical += speed * _delta * mult * direction
			
		if SAInput.ui_cancel:
			credits.hide()
			mm_control.show()
			is_scrolling = false
			#scroll.scroll_vertical = 0
			play_button.grab_focus()

func _press_play():
	SASignals.ToggleLoading.emit(true)
	SASignals.FocusedOnUi.emit(true)
	SASignals.LoadWorld.emit("world_01")

func _press_credits():
	mm_control.hide()
	credits.show()
	start_scrolling()

func start_scrolling():
	if !is_scrolling:
		await get_tree().create_timer(0.5).timeout
		is_scrolling = true
