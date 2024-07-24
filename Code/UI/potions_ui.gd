extends Control

const POTION_BOX = preload("res://Scenes/UI/potion_box.tscn")

@onready var hbox:HBoxContainer = %hbox
@onready var background_nine_rect:NinePatchRect = %background_nine_rect

var potions:Array[PotionData] = []
var boxs := []

func _ready():
	SASignals.AddPotion.connect(_add_potion)
	SASignals.PotionSelectionChanged.connect(_update_selection)

func _add_potion(_potion:PotionData):
	for each in potions:
		if each.id == _potion.id:
			print("Potion already in UI")
			return
	potions.append(_potion)
	
	var new_box = POTION_BOX.instantiate()
	hbox.add_child(new_box)
	new_box.sprite.texture = _potion.potion_icon.texture
	new_box.data = _potion
	boxs.append(new_box)
	
	background_nine_rect.size.x += hbox.size.x - 5
	position.x = 160 - (background_nine_rect.size.x/2)

func _update_selection(_value:=0):
	var x = 0
	for each in boxs:
		each.remove_selection()
		if x == _value:
			each.display_selection()
		x += 1
