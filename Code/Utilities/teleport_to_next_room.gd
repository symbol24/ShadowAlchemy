class_name DoorTeleporter extends Area2D

var room:SARooms

func _ready():
	name = "teleporter"
	body_entered.connect(_body_entered)
	room = get_parent() as SARooms
	

func _body_entered(_body):
	if _body.is_in_group("main_character"):
		if GameMode.world.get_active_room() != room:
			SASignals.UpdateActiveRoom.emit(room)
