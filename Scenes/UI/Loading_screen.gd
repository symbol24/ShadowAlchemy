class_name LoadingScreen extends Control

@onready var loading_label:Label = %loading_label
@onready var animator:AnimationPlayer = %animator

var char_count := 0
var current := 0
var timer := 0.0
var show_delay := 0.2
var char_update := false

func _ready():
	char_count = loading_label.get_total_character_count()
	loading_label.set_visible_characters(0)
	SASignals.ToggleLoading.connect(_toggle_loading)

func _process(_delta):
	if visible:
		if !animator.is_playing(): animator.play("loop")
		if char_update:
			char_update = false
			current = _show_next_char(current, char_count)
		else:
			timer += _delta
			if timer >= show_delay:
				timer = 0.0
				char_update = true
	else:
		if animator.is_playing(): animator.stop()

func _show_next_char(_current := 0, _max := 1) -> int:
	_current += 1
	if _current > _max: _current = 0
	loading_label.set_visible_characters(_current)
	return _current

func _toggle_loading(_value := true):
	if _value: show()
	else: hide()
