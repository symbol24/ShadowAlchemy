extends Node

enum ELEMENT {LIGHT, DARK, FIRE, AIR, EARTH, WATER}

var playing := true:
	set(value):
		SASignals.IsPlaying.emit(value)
		playing = true
var world = null
var camera:Camera2D = null
var character:SAMainCharacter = null
		
func _ready():
	SASignals.WorldReady.connect(set_world)
	SASignals.CharacterReady.connect(set_character)

func is_playing() -> bool:
	return playing

func set_world(_value):
	if _value: world = _value
	camera = get_tree().get_first_node_in_group("camera")
	if camera and character: connect_camera_remote(camera, character.camera_remote)

func set_character(_value):
	if _value is SAMainCharacter:
		character = _value
		if camera and character: connect_camera_remote(camera, character.camera_remote)

func connect_camera_remote(_camera, _remote:RemoteTransform2D):
	_remote.set_remote_node(_camera.get_path())
