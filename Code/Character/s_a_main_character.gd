class_name SAMainCharacter extends SACharacterBody2D

@onready var camera_remote:RemoteTransform2D = %camera_remote

func _ready():
	super._ready()
	if !camera_remote.is_node_ready(): await camera_remote.ready
	SASignals.UpdateCharaterState.connect(_update_state)
	SASignals.CharacterReady.emit(self)
	SASignals.HPUpdated.emit(data, 0.0)
	
func character_dead():
	SASignals.PlayerDead.emit()
