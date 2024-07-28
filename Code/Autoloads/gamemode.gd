extends Node

const WORLDS = [preload("res://Data/Worlds/main_menu.tres"), preload("res://Data/Worlds/test.tres"), preload("res://Data/Worlds/world_01.tres")]
const MAIN_CHARACTER = preload("res://Scenes/Character/main_character.tscn")

enum ELEMENT {LIGHT, DARK, FIRE, AIR, EARTH, WATER, HEAL}
enum BUTTON {ACTION1, ACTION2, ACTION3, ACTION4, ACTION5, ACTION6, ACTION7, ACTION8, SELECT, START, MOVE, AIM}

var playing := true:
	set(value):
		SASignals.IsPlaying.emit(value)
		playing = value
var camera:Camera2D = null

#Loading
var world:SAWorld = null
var loading := ""
var is_loading := false
var load_complete := false
var loading_status := 0.0
var progress := []
var ui_ready := false

#spawning
var character:SAMainCharacter = null
var spawn_point: Marker2D = null

func _ready():
	SASignals.WorldReady.connect(_spawn_character)
	SASignals.CameraReady.connect(_set_camera)
	SASignals.CharacterReady.connect(_set_character)
	SASignals.PauseGame.connect(_toggle_pause)
	SASignals.LoadWorld.connect(_load_world)
	SASignals.UIDone.connect(_receive_ui_done)

func _process(_delta):
	if is_loading:
			loading_status = ResourceLoader.load_threaded_get_status(loading, progress)
			if loading_status == ResourceLoader.THREAD_LOAD_LOADED:
				if !load_complete:
					load_complete = true
					print("loading complete of ", loading)
					_complete_load()

func _complete_load():
	is_loading = false
	var new_world = ResourceLoader.load_threaded_get(loading)
	if world:
		world.queue_free()
		world = null
	world = new_world.instantiate() as SAWorld
	if get_tree().paused: get_tree().paused = false
	add_child(world)
	load_complete = false

func is_playing() -> bool:
	return playing

func _load_world(_id := ""):
	print("attempting to load ", _id)
	loading = _get_world(_id)
	print("found ", loading)
	if loading:
		ResourceLoader.load_threaded_request(loading)
		is_loading = true

func _get_world(_id := ""):
	var found := false
	var _path := ""
	for data in WORLDS:
		if data.id == _id:
			_path = data.scene_path
			found = true
			break
	if found:
		return _path
	printerr("World ", _id, " not found")
	return ""

func _set_world(_value):
	if _value: 
		if world:
			world.queue_free()
			world = null
		world = _value

func _set_character(_value):
	if _value is SAMainCharacter:
		character = _value
		SASignals.CharacterInGamemode.emit(character)

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

func _toggle_pause(_value := false):
	playing = !_value
	get_tree().set_pause(_value)

func _spawn_character(_world:SAWorld):
	if !world: world = _world
	if _world.data.spawn_character:
		var temp = _world.spawn_point
		if temp:
			var new_character = MAIN_CHARACTER.instantiate()
			new_character.global_position = temp.global_position
			_world.add_child(new_character)
	
func _receive_ui_done(_value := false):
	ui_ready = _value
	if ui_ready and character:
		SASignals.ToggleLoading.emit(false)
		SASignals.FocusedOnUi.emit(false)
		_toggle_pause(false)

func _set_camera_pos(_pos := Vector2.ZERO):
	if camera: camera.global_position = _pos

func _set_camera(_camera):
	if _camera is SACamera:
		camera = _camera
