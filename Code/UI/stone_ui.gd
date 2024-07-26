extends Control

func _ready():
	SASignals.AddStone.connect(show)
