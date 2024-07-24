class_name SACharacterBody2D extends CharacterBody2D

const JUMP_TIME_TO_PEAK := 0.6
const JUMP_TIME_TO_DESCENT := 0.4
const MAX_FALL_VELOCITY := 600.0

@export var data:SACharacterData

@onready var sprite:Sprite2D = %sprite

#Base MOVEMENT values
var can_move := true
var grounded := true:
	set(value):
		var pre_value = grounded
		grounded = value
		if grounded and grounded != pre_value: SASignals.CharacterGrounded.emit(self)

func _physics_process(_delta):
	if GameMode.is_playing():
		grounded = is_on_floor()
		if !grounded: apply_gravity(_delta)
		
		move_and_slide()

func apply_gravity(_delta := 0.0):
	velocity.y += get_gravity() * _delta

func get_gravity() -> float:
	return get_jump_gravity() if velocity.y < 0.0 else get_fall_gravity()
	
func get_jump_velocity() -> float:
	var height = 100.0
	if data: height = data.jump_height
	return -((2.0 * height) / JUMP_TIME_TO_PEAK)

func get_jump_gravity() -> float:
	var height = 100.0
	if data: height = data.jump_height
	return ((2.0 * height) / (JUMP_TIME_TO_PEAK * JUMP_TIME_TO_PEAK))

func get_fall_gravity() -> float:
	var height := 100.0
	if data: height = data.jump_height
	return maxf(((2.0 * height) / (JUMP_TIME_TO_DESCENT * JUMP_TIME_TO_DESCENT)), MAX_FALL_VELOCITY)
