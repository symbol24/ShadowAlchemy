class_name MainWorld extends SAWorld

@onready var darkener = %darkener

var rooms := []
var active_room := 0
var active_spawn:Marker2D
var spawn_point

func _ready():
	if darkener: darkener.show()
	rooms = get_tree().get_nodes_in_group("room")
	SASignals.UpdateActiveRoom.connect(_set_active_room)
	_set_active_room(rooms[0])
	spawn_point = _get_spawn_point(rooms)
	await get_tree().create_timer(2).timeout
	super._ready()

func _get_spawn_point(_rooms = []):
	for room in _rooms:
		if room.spawn_point:
			return room.spawn_point
	return null

func _set_active_camera_pos(_room):
	var pos := Vector2.ZERO
	pos = Vector2(_room.global_position.x+160, _room.global_position.y+88)
	if pos != Vector2.ZERO:
		SASignals.SetCameraPos.emit(pos)

func _set_active_room(_room):
	var x = 0
	var found := false
	while x < rooms.size():
		if rooms[x] == _room:
			found = true
			break
		x += 1
	if found:
		active_room = x
		_set_active_camera_pos(rooms[x])

func get_active_room() -> SARooms:
	return rooms[active_room]

func _get_active_spawn(_room:SARooms, _arriving_from := "right") -> Marker2D:
	match _arriving_from:
		"right":
			return _room.spawn_point_left
		"left":
			return _room.spawn_point_right
		"up":
			return _room.spawn_point_down
		"down":
			return _room.spawn_point_up
		_:
			return null

func get_id_from_room(_room:SARooms) -> int:
	var id = -10
	for room in rooms:
		if room == _room:
			return id
		id += 1
	return id
