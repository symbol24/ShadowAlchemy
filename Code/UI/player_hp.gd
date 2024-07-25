extends Control

@onready var hp_bar:TextureProgressBar = %hp_bar
@onready var hp_label:Label = %hp_label

func _ready():
	SASignals.HPUpdated.connect(_update_hp)
	SASignals.MaxHPUpdated.connect(_update_hp)
	
func _update_hp(_data:SACharacterData, _change := 0.0):
	if _data and GameMode.character and _data == GameMode.character.data:
		hp_bar.value = _data.percent_hp
		hp_label.text = str(_data.current_hp) + "/" + str(_data.max_hp)
