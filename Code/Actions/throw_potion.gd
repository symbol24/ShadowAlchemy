extends SAAction

const POTIONS = [preload("res://Scenes/Potions/potion_fire.tscn"), preload("res://Scenes/Potions/potion_light.tscn")]

@export var potion_datas:Array[PotionData] = []
@export var use_const_preloads := false

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
		SASignals.PotionSelectionChanged.emit(selection)

func _ready():
	super._ready()
	var to_use:Array[PackedScene] = []
	if !use_const_preloads:
		for each in potion_datas:
			to_use.append(load(each.potion_path))
	else: to_use = POTIONS
	for each in to_use:
		var temp = each.instantiate()
		potions.append(
			{
				"potion":each,
				"data":temp.data,
				"can_throw":true,
				"timer":0.0,
				"delay":temp.data.throw_delay
			}
		)
		SASignals.AddPotion.emit(temp.data)
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
		
		if SAInput.action_5 and !toggle_pressed: selection = tab_selection(selection, true)
		elif SAInput.action_8 and !toggle_pressed: selection = tab_selection(selection, false)
		
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
		_potion["can_throw"] = false
		var new_potion = _potion["potion"].instantiate()
		GameMode.world.add_child(new_potion)
		new_potion.global_position = global_position
		new_potion.apply_central_impulse(_aim_direction.normalized() * get_final_throw_strength())


func _timer_timeout():
	can_throw = true

func get_point(_aim_direction := Vector2.ZERO, _max_length := 30.0):
	return Vector2(_max_length * _aim_direction.x, _max_length * _aim_direction.y)

func get_final_throw_strength() -> float:
	var strength:float = SAOwner.data.throw_strength
	strength = strength + ((SAOwner.data.speed/3) * (SAOwner.velocity.x / 100))
	return strength

func tab_selection(_current := 0, _left := false) -> int:
	toggle_pressed = true
	var new  = _current
	if _left: 
		new -= 1
		if new < 0: new = potions.size()-1
	else:
		new += 1
		if new >= potions.size(): new = 0
	return new
