class_name SACharacterData extends Resource

@export var id := ""

@export_subgroup("Movement")
@export var speed:float = 100
@export var jump_height:float = 100
@export var jump_count:int = 1
@export var acceleration := 700
@export var friction := 1100
@export var air_multiplier := 0.6

@export_subgroup("Health")
@export var base_hp:float = 100
@export var starting_life_count:int = 1

@export_subgroup("Defence")
@export var light_armor:float = 1
@export var dark_armor:float = 1
@export var fire_resist:float = 0.0
@export var air_resist:float = 0.0
@export var earth_resist:float = 0.0
@export var water_resist:float = 0.0

var character:SACharacterBody2D = null

var current_hp:float = 100:
	set(value):
		var pre = current_hp
		current_hp = value
		if current_hp < 0:
			current_hp = 0
		elif current_hp > max_hp:
			current_hp = max_hp
		SASignals.HPUpdated.emit(character, current_hp - pre)
		if current_hp == 0: SASignals.CharacterDead.emit(character)
var max_hp:float = 100:
	set(value):
		max_hp = value
		SASignals.MaxHPUpdated.emit(character, max_hp)
var percent_hp:
	get:
		return current_hp / max_hp

func update_hp(_value := 0):
	current_hp += _value
