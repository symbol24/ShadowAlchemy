class_name SAInteraction extends Area2D

var interactable = null
var timer := 0.0
var delay := 0.3
var can_interact := true

func _ready():
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)

func _process(_delta):
	if GameMode.is_playing() and interactable:
		if can_interact and SAInput.action_3:
			can_interact = false
			interactable.interact()
		
		if !can_interact:
			timer += _delta
			if timer >= delay:
				can_interact = true
				timer = 0.0

func _area_entered(_area):
	if _area.has_method("get_interactable"):
		interactable = _area.get_interactable()

func _area_exited(_area):
	if _area.has_method("get_interactable") and interactable:
		if interactable.name == _area.name:
			interactable = null
