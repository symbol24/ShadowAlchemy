class_name SAMainCharacter extends SACharacterBody2D

@export var god_mode := false

@onready var camera_remote:RemoteTransform2D = %camera_remote

func _ready():
	super._ready()
	if !camera_remote.is_node_ready(): await camera_remote.ready
	SASignals.CharacterReady.emit(self)
	name = "MainCharacter"
	
func character_dead():
	SASignals.PlayerDead.emit()

func _hit_detection(_area):
	if _area.has_method("get_damages") and !god_mode:
		data.receive_damage(_area.get_damages())
