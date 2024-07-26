class_name SAPopup extends Control

@onready var display_timer:Timer = %display_timer
@onready var message:Label = %message

var start_modulate
var fade_time := 0.3
var displayed := false

var backlog := []

func _ready():
	display_timer.timeout.connect(hide_popup)
	start_modulate = modulate
	SASignals.DisplaySmallPopup.connect(display)

func _process(_delta):
	if !displayed and !backlog.is_empty():
		display_backlog()

func display(_text := ""):
	if !displayed:
		displayed = true
		message.text = _text
		show()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, fade_time)
		display_timer.start()
	else:
		backlog.append(_text)

func display_backlog():
	if !backlog.is_empty():
		display(backlog.pop_front())

func hide_popup():
	if displayed:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", start_modulate, fade_time)
		await tween.finished
		hide()
		displayed = false
