extends Node

const DEFAULT = preload("res://Data/Audio/default.tres")
const MIN_DB := -60.0
const MAX_DB := 0.0

var audio_pool:Array = []
var bus_ids := ["Master", "Music", "SFX"]
var music:SAAudioStreamPlayer
var audio_check_timer := 0.0
var delay := 60.0


func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	SASignals.AudioExiting.connect(_freed_audio)

func _process(_delta):
	audio_check_timer += _delta
	if audio_check_timer >- delay:
		audio_check_timer = 0.0
		clear_audio_pool()
		
func clear_audio_pool():
	var x := 0
	var to_clear := []
	while x < audio_pool.size():
		if audio_pool[x] != null and !audio_pool[x].playing:
			to_clear.append(x)
		x += 1
	if !to_clear.is_empty():
		for i in to_clear:
			var temp = audio_pool.pop_at(i)
			temp.queue_free.call_deferred()

func play(audio:AudioFile = null, _is_2d := false):
	var new_player = SAAudioStreamPlayer.new()
	if audio != null:
		new_player.set_stream(audio.get_random_audio())
		if audio.is_music:
			new_player.bus = "Music"
			if music != null: music.stop()
			music = new_player
		else: new_player.bus = "SFX"
		#Debug.log("Audio in bus ", new_player.bus)
		new_player.volume_db = audio.volume_db
		new_player.pitch_scale = audio.get_random_pitch()
	if new_player.stream != null:
		add_child(new_player)
		audio_pool.append(new_player)
		if audio.is_music: new_player.process_mode = Node.PROCESS_MODE_ALWAYS
		new_player.play()
	return new_player

func update_audio_volume(bus_name := "master", percent := 1.0):
	if percent > -0.1 and percent <= 1.0:
		var bus_index = AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(percent))
	#Debug.log("Setting volume of ", bus_name, " and set to db ", linear_to_db(percent))

func update_volumes():
	update_audio_volume("Master", DEFAULT.master_volume)
	update_audio_volume("Music", DEFAULT.music_volume)
	update_audio_volume("SFX", DEFAULT.sfx_volume)

func _freed_audio(_audio):
	var x = 0
	var found := false
	while x < audio_pool.size():
		if _audio == audio_pool[x]:
			found = true
			break
		x += 1
	if found:
		var _temp = audio_pool.pop_at(x)
