extends SAInteractible

const SUCCESS = preload("res://Data/Audio/Files/success.tres")

@export var action := GameMode.BUTTON.ACTION3

@onready var sprite:Sprite2D = %sprite
@onready var animator:AnimationPlayer = %animator
@onready var y = %y

var text = tr("stone_pickup_popup")

func _ready():
	super._ready()

func interact():
	y.hide()
	SASignals.AddStone.emit()
	Audio.play(SUCCESS)
	SASignals.DisplaySmallPopup.emit(text)
	animator.play("pickup")

func _area_entered(_area):
	if !y.visible:
		y.show()

func _area_exited(_area):
	if y.visible:
		y.hide()
