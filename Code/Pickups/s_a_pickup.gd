class_name SAPickup extends SAInteractible

@export var potion_data:PotionData
@export var action := GameMode.BUTTON.ACTION3

@onready var sprite:Sprite2D = %sprite
@onready var animator:AnimationPlayer = %animator
@onready var y = %y

func _ready():
	super._ready()
	name = potion_data.id + "_interactible"

func interact():
	SASignals.AddPotion.emit(potion_data)
	animator.play("pickup/pickup")

func _area_entered(_area):
	if !y.visible:
		y.show()

func _area_exited(_area):
	if y.visible:
		y.hide()
