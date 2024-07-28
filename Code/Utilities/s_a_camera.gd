class_name SACamera extends Camera2D

func _ready():
	SASignals.CameraReady.emit(self)
	SASignals.SetCameraPos.connect(_set_camera_pos)
	
func _set_camera_pos(_pos):
	global_position = _pos
