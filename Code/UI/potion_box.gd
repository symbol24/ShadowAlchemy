class_name PotionBox extends Control

@onready var selector = %selector
@onready var sprite:Sprite2D = %sprite
@onready var cool_down_progress:TextureProgressBar = %cool_down_progress

var data:PotionData

func _ready():
	SASignals.PotionTimerUpdate.connect(_update_cooldown)

func remove_selection():
	selector.hide()

func display_selection():
	selector.show()

func _update_cooldown(_potion:PotionData = null, _timer := 0.0):
	if _potion and _potion == data:
		if cool_down_progress.hidden: cool_down_progress.show()
		var _max = _potion.throw_delay
		var percent = 100 - ((_timer / _max) * 100)
		if percent <= 0.0: 
			percent = 0.0
			get_tree().create_timer(0.05).timeout.connect(_delayed_hide)
		cool_down_progress.value = percent
	
func _delayed_hide():
	cool_down_progress.hide()
