class_name SACharacterBody2D extends CharacterBody2D

const JUMP_TIME_TO_PEAK := 0.6
const JUMP_TIME_TO_DESCENT := 0.4
const MAX_FALL_VELOCITY := 600.0

enum STATE {IDLE, WALKING, JUMPING, FALLING, DEAD}

@export var data:SACharacterData

@onready var sprite:Sprite2D = %sprite
@onready var animator:AnimationPlayer = %animator

#Base MOVEMENT values
var can_move := true
var grounded := true:
	set(value):
		var pre_value = grounded
		grounded = value
		if grounded and grounded != pre_value: SASignals.CharacterGrounded.emit(self)

#For flipping sprite and other objects
var direction := 0.0:
	set(_value):
		direction = _value
		if GameMode.is_playing() and grounded and direction != 0.0: _update_state(STATE.WALKING)
var to_flip := []

#STATEMACHINE
var current_state := STATE.IDLE

func _ready():
	to_flip = get_tree().get_nodes_in_group("to_flip")
	SASignals.UpdateAnimation.connect(_update_animation)
	SASignals.CharacterDead.connect(_death)

func _physics_process(_delta):
	if GameMode.is_playing():
		grounded = is_on_floor()
		if !grounded: _apply_gravity(_delta)
		
		move_and_slide()
		
		_flip_items(direction, to_flip)
		_direction_check(direction)
		_state_check_for_animation(current_state)

func _direction_check(_direction := 0.0):
	if _direction < 0.1 and _direction > -0.1:
		if current_state == STATE.WALKING:
			_update_state(STATE.IDLE)
	elif _direction > 0.1 and _direction < -0.1:
		if current_state == STATE.IDLE:
			_update_state(STATE.WALKING)

func _state_check_for_animation(_state := STATE.IDLE):
	match _state:
		STATE.IDLE:
			_update_animation(self, "idle")
		STATE.WALKING:
			_update_animation(self, "walk")
		STATE.JUMPING:
			_update_animation(self, "jump")
		STATE.FALLING:
			_update_animation(self, "fall")

func _apply_gravity(_delta := 0.0):
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

func _flip_items(_direction := 1.0, _items := []):
	if (direction > 0 and sprite.flip_h) or (direction < 0 and !sprite.flip_h):
		for each in _items:
			if each.position.x != 0:
				each.position.x = -each.position.x
			if each is Sprite2D:
				each.flip_h = !each.flip_h

func _update_state(_new_state := STATE.IDLE):
	if current_state != _new_state: current_state = _new_state

func _update_animation(_character:SACharacterBody2D = null, _new_anim := ""):
	if _character == self and animator.current_animation != _new_anim:
		#print("NEW ANIMATION: ", _new_anim)
		animator.play(_new_anim)

func _death(_data):
	if _data == data:
		_update_state(STATE.DEAD)
		_update_animation(self, "death")

func character_dead():
	pass
