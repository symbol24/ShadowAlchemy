class_name Boot extends SAWorld

@onready var godot = %godot
@onready var rid = %rid
@onready var rid_back = %rid_back
@onready var rid_glasses = %rid_glasses
@onready var company = %company
@onready var timer:Timer = %timer

var id := 0

func _ready():
	timer.timeout.connect(_timer_timeout)
	display_logos(id)
	GameMode.world = self

func display_logos(_value := 0):
	var to_display
	var tween_timer := 0.1
	var delay_timer := 5.0
	match _value:
		0:
			godot.show()
			to_display = godot
			tween_timer = 0.5
		1:
			godot.hide()
			rid.show()
			to_display = rid_back
			tween_timer = 0.5
			delay_timer = 1.0
		2:
			rid_glasses.show()
			to_display = rid_glasses
			tween_timer = 0.5
			delay_timer = 1.0
		3:
			company.show()
			to_display = company
			tween_timer = 0.5
			delay_timer = 3.0
		_:
			to_display = null
			SASignals.LoadWorld.emit("main_menu")
	
	if to_display:
		var tween = get_tree().create_tween()
		tween.tween_property(to_display, "modulate", Color.WHITE, tween_timer)
		timer.wait_time = delay_timer
		timer.start()

func _timer_timeout():
	id += 1
	display_logos(id)
