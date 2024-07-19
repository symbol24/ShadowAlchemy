class_name SAWorld extends Node2D

func _ready():
	SASignals.WorldReady.emit(self)
