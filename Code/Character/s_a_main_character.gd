class_name SAMainCharacter extends SACharacterBody2D

@onready var camera_remote:RemoteTransform2D = %camera_remote

func _ready():
	if !camera_remote.is_node_ready(): await camera_remote.ready
	SASignals.CharacterReady.emit(self)
