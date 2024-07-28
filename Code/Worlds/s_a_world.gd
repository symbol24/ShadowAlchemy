class_name SAWorld extends Node2D

@export var data:SAWorldData

func _ready():
	SASignals.TogglePlayerUi.emit(data.display_player_ui)
	SASignals.WorldReady.emit(self)
