extends CanvasLayer

@onready var player_ui:Control = %PlayerUI

func _ready():
	SASignals.TogglePlayerUi.connect(_toggle_player_ui)
	
func _toggle_player_ui(_value := true):
	player_ui.visible = _value
