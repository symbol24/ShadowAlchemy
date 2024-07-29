extends SAAction

@onready var panel = %panel

var has_stone := false
var can_emit := true

func _ready():
	SASignals.AddStone.connect(_toggle_stone)

func _process(_delta):
	if GameMode.is_playing() and has_stone and can_emit and SAInput.action_3:
		can_emit = false
		_end_run()

func _toggle_stone():
	has_stone = true
	panel.show()

func _end_run():
	SASignals.GameSucces.emit()
