class_name SAAudioStreamPlayer extends AudioStreamPlayer

func _ready():
	tree_exiting.connect(_exiting_tree)
	
func _exiting_tree():
	SASignals.AudioExiting.emit(self)
