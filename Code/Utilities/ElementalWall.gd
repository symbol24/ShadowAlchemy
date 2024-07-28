extends Area2D

@export var element := GameMode.ELEMENT.AIR
@export var color_modulation:Color

@onready var sprite:Sprite2D = %sprite
@onready var animator:AnimationPlayer = %animator

var active := true

func _ready():
	sprite.modulate = color_modulation

func _area_entered(_area):
	if _area is SAThrowablePotion:
		if GameMode.check_elements(element, [_area.data.element]):
			animator.play("deactivate")
