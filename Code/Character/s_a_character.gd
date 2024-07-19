class_name SACharacterBody2D extends CharacterBody2D

const JUMP_TIME_TO_PEAK := 0.6
const JUMP_TIME_TO_DESCENT := 0.4
const MAX_FALL_VELOCITY := 600.0

@export var data:SACharacterData

@onready var ground_rays:Array[RayCast2D] = [%left, %center, %right]
@onready var sprite:Sprite2D = %sprite

#Base MOVEMENT values
var can_move := true
var grounded := false:
	set(value):
		var pre_value = grounded
		grounded = value
		if grounded and grounded != pre_value: SASignals.CharacterLanded.emit(self)

func _physics_process(_delta):
	if GameMode.is_playing():
		grounded = check_grounded(ground_rays)
		if !grounded: apply_gravity(_delta)
		
		move_and_slide()

func apply_gravity(_delta := 0.0):
	velocity.y += get_gravity() * _delta

func check_grounded(rays:Array[RayCast2D] = []) -> bool:
	var count := 0
	for each in rays:
		each.force_raycast_update()
		if each.is_colliding(): count += 1

	return count >= 2

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
