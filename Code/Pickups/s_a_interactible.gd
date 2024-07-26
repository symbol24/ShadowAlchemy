class_name SAInteractible extends Area2D

func _ready():
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)

func interact():
	pass

func _area_entered(_area):
	pass
	
func _area_exited(_area):
	pass

func get_interactable() -> SAInteractible:
	return self
