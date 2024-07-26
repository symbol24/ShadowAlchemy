extends SAAction

const STARTERS = [preload("res://Data/Potions/heal_potion.tres"), preload("res://Data/Potions/fire_potion.tres")]

@export var potion_datas:Array[PotionData] = []

@onready var aim_line:Line2D = %aim_line

var can_throw := true
var aim_direction := Vector2.ZERO
var max_radius := 30.0
var toggle_pressed := false
var toggle_delay := 0.3
var toggle_timer := 0.0
var potions:Array[Dictionary] = []

var selection := 0:
	set(value):
		selection = value
		if selection >= potions.size(): selection = 0
		elif selection < 0: selection = potions.size()-1
		SASignals.PotionSelectionChanged.emit(selection)

func _ready():
	SASignals.AddPotion.connect(_add_potion)
	super._ready()
	for data in STARTERS:
		SASignals.AddPotion.emit(data)
	SASignals.PotionSelectionChanged.emit(selection)

func _process(_delta):
	if SAOwner and GameMode.is_playing():
		aim_direction = aim()
		if aim_direction != Vector2.ZERO: 
			aim_line.show()
			aim_line.set_point_position(1, get_point(aim_direction, max_radius))
		else:
			aim_line.hide()
		if aim_direction != Vector2.ZERO and SAInput.action_7:
			throw(aim_direction.normalized(), potions[selection])
		elif aim_direction == Vector2.ZERO and SAInput.action_7 and potions[selection]["data"].element == GameMode.ELEMENT.HEAL:
			throw(aim_direction.normalized(), potions[selection])
		
		if SAInput.action_5 and !toggle_pressed: 
			toggle_pressed = true
			selection -= 1
		elif SAInput.action_8 and !toggle_pressed: 
			toggle_pressed = true
			selection += 1
		
		for each in potions:
			if !each["can_throw"]:
				each["timer"] += _delta
				SASignals.PotionTimerUpdate.emit(each["data"], each["timer"])
				if each["timer"] >= each["delay"]:
					each["timer"] = 0.0
					SASignals.PotionTimerUpdate.emit(each["data"], each["timer"])
					each["can_throw"] = true
		
		if toggle_pressed:
			toggle_timer += _delta
			if toggle_timer >= toggle_delay:
				toggle_pressed = false
				toggle_timer = 0.0

func aim() -> Vector2:
	return Vector2(SAInput.aim_left_right, SAInput.aim_up_down)

func throw(_aim_direction:=Vector2.ZERO, _potion:Dictionary = {}):
	if _potion.has("potion") and _potion["can_throw"]:
		if _potion["data"].element != GameMode.ELEMENT.HEAL:
			_potion["can_throw"] = false
			var new_potion = _potion["potion"].instantiate()
			GameMode.world.add_child(new_potion)
			new_potion.global_position = global_position
			new_potion.apply_central_impulse(_aim_direction.normalized() * get_final_throw_strength())
		elif _potion["data"].element == GameMode.ELEMENT.HEAL:
			_potion["can_throw"] = false
			SASignals.HealCharacter.emit(GameMode.character, _potion["data"].heal_value)


func _timer_timeout():
	can_throw = true

func get_point(_aim_direction := Vector2.ZERO, _max_length := 30.0):
	return Vector2(_max_length * _aim_direction.x, _max_length * _aim_direction.y)

func get_final_throw_strength() -> float:
	var strength:float = SAOwner.data.throw_strength
	strength = strength + ((SAOwner.data.speed/3) * (SAOwner.velocity.x / 100))
	return strength

func tab_selection(_left := false) -> int:
	toggle_pressed = true
	if _left: return -1
	return 1

func _add_potion(_new_potion:PotionData = null):
	if _new_potion:
		var loaded = load(_new_potion.potion_path)
		potions.append(
			{
				"potion":loaded,
				"data":_new_potion,
				"can_throw":true,
				"timer":0.0,
				"delay":_new_potion.throw_delay
			}
		)
