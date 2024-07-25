class_name SAEnemyAction extends SAAction

var target:SAMainCharacter

func _process(_delta):
	if !target and GameMode.character: _set_target(GameMode.character)

func _set_target(_value:SACharacterBody2D = null):
	if _value is SAMainCharacter:
		target = _value

func get_distance_to_target(_target:SAMainCharacter = null) -> float:
	if _target:
		#print(global_position.distance_squared_to(_target.global_position))
		return global_position.distance_squared_to(_target.global_position)
	
	return 10000000
