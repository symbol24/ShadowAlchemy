extends Node

enum ELEMENT {LIGHT, DARK, FIRE, AIR, EARTH, WATER, HEAL}
enum BUTTON {ACTION1, ACTION2, ACTION3, ACTION4, ACTION5, ACTION6, ACTION7, ACTION8, SELECT, START, MOVE, AIM}

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
	SASignals.PauseGame.connect(toggle_pause)

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
		SASignals.CharacterInGamemode.emit(character)

func connect_camera_remote(_camera, _remote:RemoteTransform2D):
	_remote.set_remote_node(_camera.get_path())

func check_elements(_to_check:GameMode.ELEMENT, _elements:Array[GameMode.ELEMENT]) -> bool:
	var found := false
	for each in _elements:
		match each:
			GameMode.ELEMENT.AIR:
				if _to_check == GameMode.ELEMENT.EARTH: found = true
			GameMode.ELEMENT.EARTH:
				if _to_check == GameMode.ELEMENT.WATER: found = true
			GameMode.ELEMENT.WATER:
				if _to_check == GameMode.ELEMENT.FIRE: found = true
			GameMode.ELEMENT.FIRE:
				if _to_check == GameMode.ELEMENT.AIR: found = true
	return found

func toggle_pause(_value := false):
	playing = !_value
	get_tree().set_pause(_value)
