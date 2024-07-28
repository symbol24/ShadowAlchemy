extends Control

const POTION_BOX = preload("res://Scenes/UI/potion_box.tscn")

@onready var hbox:HBoxContainer = %hbox
@onready var background_nine_rect:NinePatchRect = %background_nine_rect

var potions:Array[PotionData] = []
var boxs := []
var width := 20.0
var spacer := 5.0
var starter_count := 0
var setup := true

func _ready():
	SASignals.SendHowanyStarterPotions.connect(_set_starter_count)
	SASignals.AddPotion.connect(_add_potion)
	SASignals.PotionSelectionChanged.connect(_update_selection)

func _set_starter_count(_value := 0):
	starter_count = _value

func _add_potion(_potion:PotionData):
	for each in potions:
		if each.id == _potion.id:
			print("Potion already in UI")
			return
	potions.append(_potion)
	
	var new_box = POTION_BOX.instantiate()
	hbox.add_child.call_deferred(new_box)
	new_box.data = _potion
	new_box.set_icon()
	boxs.append(new_box)
	
	background_nine_rect.size.x = (width * potions.size()) + spacer
	background_nine_rect.position.x = 160 - (background_nine_rect.size.x/2)
	
	if setup and starter_count >= boxs.size():
		setup = false
		SASignals.UIDone.emit(true)

func _update_selection(_value:=0):
	var x = 0
	for each in boxs:
		each.remove_selection()
		if x == _value:
			each.display_selection()
		x += 1
