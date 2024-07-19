extends Node

var playing := true:
	set(value):
		SASignals.IsPlaying.emit(value)
		playing = true
var world = null
		
func _ready():
	SASignals.WorldReady.connect(set_world)

func is_playing() -> bool:
	return playing

func set_world(_value):
	if _value: world = _value
